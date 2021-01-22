$newDNSServers = "127.0.0.1", $dns
$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -And ($_.IPAddress).StartsWith($subnet) }
if ($adapters) {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting DNS to $dns"
    $adapters | ForEach-Object {$_.SetDNSServerSearchOrder($newDNSServers)}
}
