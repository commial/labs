# Enable RestrictedAdmin
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Enable RestrictedAdmin on SRV..."
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name "DisableRestrictedAdmin" -Value 0