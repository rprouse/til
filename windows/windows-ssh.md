# SSH into Windows

Remote-SSH supports Windows hosts; the requirement is just that the target is running an SSH server. VS Code then installs its server component on the Windows box, your extensions and terminals run there, and you get the same experience you're used to from Linux, except the integrated terminal is PowerShell.

## Setup

Install OpenSSH Server `winget install --id Microsoft.OpenSSH.Preview`.

Then open the firewall from an admin command prompt,

```sh
netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22
```

Optionally make PowerShell the default shell for SSH sessions (otherwise you land in cmd.exe). First, don't use the Microsoft Store or WinGet versions, use the MSI installer.

```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell `
  -Value "C:\Program Files\PowerShell\7\pwsh.exe" -PropertyType String -Force
```

The one gotcha worth knowing in advance: if your Windows account is an administrator, key-based auth does not read `~/.ssh/authorized_keys`. Keys go in `C:\ProgramData\ssh\administrators_authorized_keys`, and that file needs tight ACLs (SYSTEM and Administrators only) or sshd silently ignores it. Password auth works out of the box if you'd rather skip that.
