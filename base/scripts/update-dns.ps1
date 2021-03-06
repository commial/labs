Param (
    [string]$Ip
)

$subnet = $Ip -replace "\.\d+$", ""

$newDNSServers = "127.0.0.1", $Ip
$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -And ($_.IPAddress).StartsWith($subnet) }
if ($adapters) {
    Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Setting DNS to $newDNSServers"
    $adapters | ForEach-Object {$_.SetDNSServerSearchOrder($newDNSServers)}
}
