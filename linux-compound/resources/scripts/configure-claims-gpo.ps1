# Purpose: Install the GPO that enable the support for Kerberos claims
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Importing the GPO to enable Kerberos Armoring, compound authent and claims..."
Import-GPO -BackupGpoName 'Enable Claims Support' -Path "c:\vagrant\resources\GPO\claims_support" -TargetName 'Enable Claims Support' -CreateIfNeeded
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Link the GPO to the domain"
New-GPLink -Name 'Enable Claims Support' -Target "DC=windomain,DC=local" -Enforced yes

gpupdate /force
