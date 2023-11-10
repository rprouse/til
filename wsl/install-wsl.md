# Install WSL 2

Run PowerShell as Admin,

```ps
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

Restart

```ps
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

Restart then download and install the [Linux Kernel](https://aka.ms/wsl2kernel)

```cmd
wsl --set-default-version 2
wsl --list --verbose
```
