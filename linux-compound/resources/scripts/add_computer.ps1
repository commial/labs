Import-Module ActiveDirectory

New-ADComputer -Name "CLIENT" -SamAccountName "CLIENT" -Path "OU=Workstations,DC=WINDOMAIN,DC=LOCAL"

cmd.exe /c "net user CLIENT$ 123456 /domain"