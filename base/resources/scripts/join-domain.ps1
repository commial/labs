# Purpose: Joins a Windows host to the windomain.local domain which was created with "create-domain.ps1".
# Source: https://github.com/StefanScherer/adfs2
$domain=$args[0]
$dns=$args[1]

if ((gwmi win32_computersystem).partofdomain -eq $false) {
  $subnet = $dns -replace "\.\d+$", ""

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Joining the domain..."

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) First, set DNS to DC to join the domain..."

  $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPAddress -match $subnet}
  $adapters | ForEach-Object {$_.SetDNSServerSearchOrder($dns)}

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Now join the domain..."
  $hostname = $(hostname)
  $user = "$domain\vagrant"
  $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
  $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass

  $dc1, $dc2=$domain.split('.')
  # Place the computer in the correct OU based on hostname
  If ($hostname -eq "srv") {
    Add-Computer -DomainName $domain -credential $DomainCred -OUPath "ou=Servers,dc=$dc1,dc=$dc2" -PassThru
  } ElseIf ($hostname -eq "win10") {
    Write-Host "Adding Win10 to the domain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
    Add-Computer -DomainName $domain -credential $DomainCred -OUPath "ou=Workstations,dc=$dc1,dc=$dc2"
  } Else {
    Add-Computer -DomainName $domain -credential $DomainCred -PassThru
  }

  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "vagrant"
  Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "vagrant"

  # Stop Windows Update
  Write-Host "Disabling Windows Updates and Windows Module Services"
  Set-Service wuauserv -StartupType Disabled
  Stop-Service wuauserv
  Set-Service TrustedInstaller -StartupType Disabled
  Stop-Service TrustedInstaller
}