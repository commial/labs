Param (
    [string]$Domain
)

Import-Module ActiveDirectory

New-ADGroup -Name "Servers Administrators" -SamAccountName ServersAdministrators -GroupCategory Security -GroupScope Global -DisplayName "Servers Administrators" -Path "CN=Users,DC=windomain,DC=local" -Description "Members of this group are administrators of servers"

New-ADUser -Name "pikachu" -GivenName "Pik" -Surname "Achu" -SamAccountName "pikachu" -UserPrincipalName "pikachu@$Domain" -AccountPassword (ConvertTo-SecureString -AsPlainText "Bonjour1!" -Force) -Enabled $true

Get-ADGroup -Identity "ServersAdministrators" | Add-ADGroupMember -Members "pikachu"
Get-ADGroup -Identity "Remote Desktop Users" | Add-ADGroupMember -Members "ServersAdministrators"
