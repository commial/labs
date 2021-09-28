# Purpose: Joins a Windows host to the windomain.local domain which was created with "create-domain.ps1".
# Source: https://github.com/StefanScherer/adfs2


Param (
  [string]$Domain,
  [string]$Dns
)

if ((gwmi win32_computersystem).partofdomain -eq $false) {
  $subnet = $dns -replace "\.\d+$", ""

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Joining the domain $Domain ..."
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) First, set DNS to DC to join the domain ($Dns)..."

  $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPAddress -match $subnet}
  $adapters | ForEach-Object {$_.SetDNSServerSearchOrder($Dns)}

  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Now join the domain..."
  $hostname = $(hostname)
  $user = "$Domain\vagrant"
  $pass = ConvertTo-SecureString "vagrant" -AsPlainText -Force
  $DomainCred = New-Object System.Management.Automation.PSCredential $user, $pass

  $dc1, $dc2=$Domain.split('.')
  # Place the computer in the correct OU based on hostname
  If ($hostname -eq "srv") {
    Add-Computer -DomainName $Domain -credential $DomainCred -OUPath "ou=Servers,dc=$dc1,dc=$dc2" -PassThru
  } ElseIf ($hostname -eq "win10") {
    Write-Host "Adding Win10 to the domain. Sometimes this step times out. If that happens, just run 'vagrant reload win10 --provision'" #debug
    Add-Computer -DomainName $Domain -credential $DomainCred -OUPath "ou=Workstations,dc=$dc1,dc=$dc2"
  } Else {
    Add-Computer -DomainName $Domain -credential $DomainCred -PassThru
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