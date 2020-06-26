# Fix Windows Explorer
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

choco install -y googlechrome
choco install -y visualstudio2019professional
choco install -y visualstudio2019-workload-nativedesktop
choco install -y firefox
choco install -y 7zip
choco install -y notepadplusplus
choco install -y winpcap
choco install -y wireshark
choco install -y processhacker
choco install -y procexp
choco install -y windbg -params '"/SymbolPath:c:\symbols"'
choco install -y windows-sdk-10-version-1809-windbg
choco install -y adobereader
choco install -y hxd
choco install -y rsat
choco install git -y -params '"/GitAndUnixToolsOnPath /NoAutoCrlf"'
 
Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
Install-ChocolateyPinnedTaskBarItem "${env:ProgramFiles(x86)}\Mozilla Firefox\firefox.exe"
# 
