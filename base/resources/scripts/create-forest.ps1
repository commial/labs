# Purpose: Creates the  domain
# Source: https://github.com/StefanScherer/adfs2

$ip=$args[0]
$domain=$args[1]
$dns=$args[2]

$subnet=$ip -replace "\.\d+$", ""

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Forest $domain ..."

if ((gwmi win32_computersystem).partofdomain -eq $false) {

 . c:\vagrant\resources\scripts\prepare-domain.ps1 

  # Windows Server 2016 R2
  Install-WindowsFeature AD-domain-services
  Import-Module ADDSDeployment
  Install-ADDSForest `
    -SafeModeAdministratorPassword $SecurePassword `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "7" `
    -DomainName $domain `
    -ForestMode "7" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true
  
 . c:\vagrant\resources\scripts\update-dns.ps1 

}
