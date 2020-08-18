 $ChocoInstallPath = "$env:SystemDrive\\ProgramData\\boxstarter\\Boxstarter.Chocolatey"

# Install Boxstarter

if (!(Test-Path $ChocoInstallPath)) {
  . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
  Import-Module $ChocoInstallPath
  Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
  Set-TimeZone "Romance Standard Time"
  Set-WinUserLanguageList -LanguageList en-US,fr-FR -Force
  Set-MpPreference -DisableRealtimeMonitoring $true
}
