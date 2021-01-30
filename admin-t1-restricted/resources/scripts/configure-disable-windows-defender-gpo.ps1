# Purpose: Install the GPO that disables Windows Defender

Param (
    [string]$Domain
)

$dc1,$dc2=$Domain.split('.')

Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Importing the GPO to disable Windows Defender..."
Import-GPO -BackupGpoName 'Disable Windows Defender' -Path "c:\vagrant\resources\GPO\disable_windows_defender" -TargetName 'Disable Windows Defender' -CreateIfNeeded

$OU = "ou=Servers,dc=$dc1,dc=$dc2"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Disable Windows Defender'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name 'Disable Windows Defender' -Target $OU -Enforced yes
}
else
{
  Write-Host "Disable Windows Defender GPO was already linked at $OU. Moving On."
}
gpupdate /force
