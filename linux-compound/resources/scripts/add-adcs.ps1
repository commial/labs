$Credential = New-Object System.Management.Automation.PSCredential "WINDOMAIN\Administrator", (ConvertTo-SecureString -AsPlainText "vagrant" -Force)

Invoke-Command -Credential $Credential -Computer DC -ScriptBlock {

    # Install a EntrepriseRootCa
    Install-WindowsFeature Adcs-Cert-Authority -includeManagementTools
    Install-AdcsCertificationAuthority -CAType EnterpriseRootCa -Force -Credential $Credential

    # Add a GPO for Auto Enrollment of DC
    Import-GPO -BackupGpoName 'AutoEnrollment' -Path "c:\vagrant\resources\GPO\adcs\" -TargetName 'AutoEnrollment' -CreateIfNeeded
    $OU = "ou=Domain Controllers,dc=windomain,dc=local"
    $gPLinks = $null
    $gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
    $GPO = Get-GPO -Name 'AutoEnrollment'
    If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
    {
    New-GPLink -Name 'AutoEnrollment' -Target $OU -Enforced yes
    }
    gpupdate /force

    # Import the certificate template
    # Note: exported with: ldifde -m -v -d "CN=KerberosAuthenticationClient,CN=Certificate Templates,CN=Public Key Services,CN=Services,CN=Configuration,DC=windomain,DC=local" -f kauthtpl.ldf
    # Note: the template is unsecure, allowing anyone to make custom request
    #       DO NOT USE IT IN PRODUCTION
    ldifde -i -k -f C:\vagrant\resources\kauthtpl.ldf
    
    # Add the template to the CA (certsrv -> "Certificate template to issue")
    Add-CATemplate -Name "KerberosAuthenticationClient" -Force

    # Request a certificate for CLIENT$
    Get-Certificate -Template KerberosAuthenticationClient -DnsName "client.windomain.local" -CertStoreLocation cert:\LocalMachine\My -SubjectName "CN=client@WINDOMAIN.LOCAL"

    # Export it
    $mypwd = ConvertTo-SecureString -String "dummypassword" -Force -AsPlainText
    Get-ChildItem -Path cert:\localMachine\my | Where-Object { $_.Subject -like '*client@WINDOMAIN.LOCAL*' } | Export-PfxCertificate -FilePath C:\vagrant\mypfx.pfx -Password $mypwd
}