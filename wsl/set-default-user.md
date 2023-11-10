# Set the Default User back from Root after Importing WSL Distro

When you export a WSL distro then import it, the default user is switched to the `root` user. This will set it back to your username, `rob` in my case.

```ps
Function WSL-SetDefaultUser ($distro, $user) { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); };

WSL-SetDefaultUser <DistroName> <UserName>
```
