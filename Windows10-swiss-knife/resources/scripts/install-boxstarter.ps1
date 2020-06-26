Set-TimeZone "Romance Standard Time"
Set-WinUserLanguageList -LanguageList en-US,fr-FR -Force

# Disable Windows Defender
Set-MpPreference -DisableRealtimeMonitoring $true

# Install Boxstarter
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force

Import-Module "$env:ProgramData\boxstarter\Boxstarter.Chocolatey"

$credential = New-Object System.Management.Automation.PSCredential("vagrant", (ConvertTo-SecureString "vagrant" -AsPlainText -Force))
Install-BoxstarterPackage c:\vagrant\resources\scripts\setup.ps1 -Credential $credential -DisableReboots

