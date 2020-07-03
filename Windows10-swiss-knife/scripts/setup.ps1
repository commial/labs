choco install -y googlechrome
choco install -y visualstudio2019community
choco install -y visualstudio2019-workload-nativedesktop
choco install -y visualstudio2019-workload-vctools
# Add mandatory component for Mimikatz compilation
choco install -y visualstudio2017-workload-vctools --package-parameters "--add Microsoft.VisualStudio.Component.WinXP --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.WinXP --includeRecommended"
choco install -y firefox
choco install -y 7zip
choco install -y notepadplusplus
choco install -y winpcap
choco install -y wireshark
choco install -y processhacker
choco install -y windbg -params '"/SymbolPath:c:\symbols"'
choco install -y windows-sdk-10-version-1809-windbg
choco install -y adobereader
choco install -y hxd
choco install -y git
choco install -y golang
choco install -y rsat -params '"/AD /GP /RD /SM"'
choco install -y sysinternals --params "/InstallDir:C:\Users\vagrant\Desktop\tools\sysinternals"
