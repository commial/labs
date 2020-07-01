Add-MpPreference -ExclusionPath 'C:\Users\vagrant\Desktop\tools'
Add-MpPreference -ExclusionPath 'C:\Users\vagrant\AppData\Local\Temp'


Function My-Last-Tag($url) {
  $tag = Invoke-WebRequest $url -UseBasicParsing | ConvertFrom-Json
  $last =  $tag |%{ $_.created_at }| Sort-Object | Select-Object -Last 1
  $tag | ?{ $_.created_at -eq $last } | %{$_.tag_name} 
}

# GitHub requires TLS 1.2 as of 2/27
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$tag =  My-Last-Tag "https://api.github.com/repos/gentilkiwi/mimikatz/releases"
$mimikatzDownloadUrl = "https://github.com/gentilkiwi/mimikatz/releases/download/$tag/mimikatz_trunk.zip"

$tag =  My-Last-Tag "https://api.github.com/repos/securesocketfunneling/ssf/releases"
$SSfURL = "https://github.com/securesocketfunneling/ssf/releases/download/3.0.0/ssf-win-x86_64-$tag.zip"

$Tools = @(
  @{ Name = "Mimikatz";     Url = $mimikatzDownloadUrl},
  @{ Name = "Powersploit";  Url = "https://github.com/PowerShellMafia/PowerSploit/archive/master.zip"},
  @{ Name = "Powercat";     Url = "https://github.com/secabstraction/PowerCat/archive/master.zip"},
  @{ Name = "PrivescCheck"; Url = "https://github.com/itm4n/PrivescCheck/archive/master.zip"},
  @{ Name = "Ssf";          Url = $SSfURL}
)

$Tools | %{
  $RepoPath = "C:\Users\vagrant\AppData\Local\Temp\$($_.Name).zip"
  $output = "C:\Users\vagrant\desktop\tools\$($_.Name)"
  
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Trying to install $($_.Name)"
  if (-not (Test-Path $RepoPath))
  {
    Invoke-WebRequest -Uri "$($_.Url)" -OutFile $RepoPath
    Expand-Archive -path "$RepoPath" -destinationpath $output -Force
  }
  else
  {
    Write-Host "$($_.Name) was already installed. Moving On."
  }
}


