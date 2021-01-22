Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing RSAT tools"
Import-Module ServerManager
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating domain controller..."
# Disable password complexity policy
secedit /export /cfg C:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
rm -force C:\secpol.cfg -confirm:$false

# Set administrator password
$computerName = $env:COMPUTERNAME
$adminPassword = "vagrant"
$adminUser = [ADSI] "WinNT://$computerName/Administrator,User"
$adminUser.SetPassword($adminPassword)

$PlainPassword = "vagrant" # "P@ssw0rd"
$SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force

