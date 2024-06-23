# Install WinGet

The first command allows you to run from PowerShell Core. Catch 22 though, I use WinGet to install PS Core 😀

```ps
Import-Module -Name Appx -UseWIndowsPowershell
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "C:\PS\WinGet.msixbundle"
Add-AppxPackage "C:\PS\WinGet.msixbundle"
```
