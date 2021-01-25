# Purpose: Creates the  domain
# Source: https://github.com/StefanScherer/adfs2

Param (
  [string]$Ip,
  [string]$Name
)

$subnet=$Ip -replace "\.\d+$", ""

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Creating Forest $Name ..."

if ((gwmi win32_computersystem).partofdomain -eq $false) {
  $SecurePassword = "vagrant" | ConvertTo-SecureString -AsPlainText -Force

  # Windows Server 2016 R2
  Install-WindowsFeature AD-domain-services
  Import-Module ADDSDeployment
  Install-ADDSForest `
    -SafeModeAdministratorPassword $SecurePassword `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "7" `
    -DomainName $Name `
    -ForestMode "7" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true
}
