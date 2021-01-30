
$domain=(gwmi win32_computersystem).Domain
# Allow vagrant user from our domain to connect via RDP
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "$domain\vagrant"

# Allow SMB (disabled by default on 2019 server)
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Domain

