$password = ConvertTo-SecureString "vagrant" -AsPlainText -Force

$Cred = New-Object System.Management.Automation.PSCredential ("Administrator", $password)

$computer = Get-ADComputer -Identity client

# SDDL: User Member of Any { computer }
$sddl = "O:SYG:SYD:(XA;OICI;CR;;;WD;(Member_of {SID("
$sddl += $computer.SID.Value
$sddl += ")}))"

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating the 'Authent Policy'..."
$parameters = @{
	    Enforce = $true
	    Name = 'Authent Policy'
	    Description = 'Allow authentication only on Client'
	    RollingNTLMSecret = 0
	    ServiceAllowedNTLMNetworkAuthentication = $false
	    UserAllowedNTLMNetworkAuthentication = $false
	    UserAllowedToAuthenticateFrom = $sddl
}
New-ADAuthenticationPolicy @parameters -Credential $Cred

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Adding 'pikachu' to 'Authent Policy'..."
$pol = Get-ADAuthenticationPolicy -Filter "Name -like 'Authent Policy'"
Get-ADUser -Identity pikachu | Set-ADObject -Replace @{'msDS-AssignedAuthNPolicy'=@($pol.DistinguishedName)} -Credential $Cred
