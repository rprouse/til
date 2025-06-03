# 🤖 Today I Learned

![Today I Learned](./img/til-banner.png)

A collection of short write-ups on small things I learn day to day across a variety of languages and technologies. These are things that don't really warrant a full blog post. These are things I've picked up by [Learning In Public™](https://dev.to/jbranchaud/how-i-built-a-learning-machine-45k9).

I blog longer form posts on Retro-Computing at [8-Bit Labs](https://8bitlabs.ca/) and if I ever get back to it, posts on more modern technologies and programming are at [Alteridem.Net](https://alteridem.net/).

Set the repo to LF endings so that I don't get screwed up jumping between Windows and Linux.

```sh
git config core.autocrlf false
git config core.eol lf
```
## 🤖 Artificial Intelligence (AI)

- [Set the GPU Affinity of Ollama on Windows](./ai/gpu_affinity.md)
- [Move Ollama models](./ai/ollama_models.md)
- [Install Open WebUI](./ai/open_webui.md)
- [Install Fabric AI](./ai/fabric.md)

## 📱 Android Development

- [ADB Error Logs](./android/adb_error_logs.md)
- [Move the Android SDK to another Drive](./android/move_sdk.md)

## ☁️ Azure

- [Local Azure Storage Development](./azure/azurite.md)

## 💻 C

- [Open and listen on a network port](./hacking/pwn.college/network_intercepts/Readme.md#listen-to-a-port)

## 🔫 C#/CSharp

- [Count Git merge commits by Author](./csharp/git-commits.md)
- [List repositories in a GitHub Organization](./csharp/github-repos.md)
- [List repositories in an Azure DevOps Project](./csharp/ado-repos.md)
- [Read a CSV File](./csharp/read-csv.md)
- ASP.NET [Renew development SSL Certificates](./csharp/aspnet-ssl.md)
- [InternalsVisibleTo](./csharp/internalsvisibleto.md) for test projects.

## 📡 Cryptography

- [One Time Pad](./hacking/pwn.college/crypto/otp.md) (OTP)
- [AES Decryption](./hacking/pwn.college/crypto/aes.md) using the ECB mode of operation
- [Diffie-Hellman](./hacking/pwn.college/crypto/diffie-hellman.md) key exchange
- [RSA](./hacking/pwn.college/crypto/rsa.md) (Rivest-Shamir-Adleman) Asymmetric Encryption
- [Public Key Certificates](./hacking/pwn.college/crypto/public_key.md)
- [TLS Handshake](./hacking/pwn.college/crypto/tls.md)

## 📦 Docker

- [Running a Container](./docker/running-container.md)
- [Attaching to a running container](./docker/attach-container.md)

## 📻 Electronics

- [SMD Resistor & Capacitor Sizes](./electronics/smd-resistors.md)

## 🐞 GDB

- [Running programs](./gdb/gdb_notes.md#running-a-program)
- [Display registers](./gdb/gdb_notes.md#display-registers)
- [Display memory](./gdb/gdb_notes.md#display-memory)
- [Stepping through a program](./gdb/gdb_notes.md#stepping-through-a-program)
- [Setting register and memory values](./gdb/gdb_notes.md#setting-register-and-memory-values)
- [Redirecting system calls](./gdb/gdb_notes.md#redirecting-system-calls)
- [TUI](./gdb/gdb_tui.md) text user interface

## 🌿 Git

- [Revert the Last Commit](./git/revert-last-commit.md)
- [View commits on all branches for a user](./git/view-user-commits.md)
- [Calculate Git commits by Author on all branches in C#](./csharp/git-commits.md)
- [Format the oneline output](./git/format-output.md)
- [Git Shallow Clone](./git/shallow-clone.md)
- [Git Submodules](./git/submodules.md)

## 👨‍💻 Hacking / Cybersecurity

- [pwn.college](./hacking/pwn.college/Readme.md) notes and code from working through the course.
- [Hack The Box](./hacking/hackthebox/Readme.md) notes from working through challenges.
- [OWASP Juice Shop](./hacking/juice_shop.md) vulnerable application.

### Tools

- [nmap](./hacking/nmap.md) Network Mapper
- [gobuster](./hacking/gobuster.md) Directory/File, DNS and VHost busting tool
- [Packet Reassembly in Wireshark](./hacking/wireshark_stream.md)
- Session [Logging](./hacking/logging.md)

### Vulnerabilities

- [Cracking WiFi WPA2-PSK2 with aircrack-ng](./hacking/aircrack-ng.md).
- [Web Command Injection](./hacking/pwn.college/web_security/command_injection.md) Vulnerability
- [Web Authentication Bypass Vulnerability](./hacking/pwn.college/web_security/auth_bypass.md) Vulnerability
- [SQL Injection](./hacking/pwn.college/web_security/sql_injection.md) Vulnerabilities
- [Cross-Site Scripting](./hacking/pwn.college/web_security/xss.md) (XSS) vlulnerabilities
- [Cross-Site Request Forgery](./hacking/pwn.college/web_security/csrf.md) (CSRF) Vulnerabilities
- [SMB](./hacking/smb.md) Server Message Block
- [File Inclusion](./hacking/file_inclusion.md) vulnerability

## 🐧 Linux

- [Man](./linux/man.md) notes
- [Switch to Virtual Consoles (TTYs)](./linux/switch-tty.md)
- [Curl notes](./hacking/pwn.college/talking_web/Readme.md#curl)
- [Set IP address](./linux/ifconfig.md#set-the-ip-address-of-an-interface)
- [Security Hardening](./linux/hardening.md) a Debian based Linux box
- [OpenVPN](./linux/openvpn.md)
- [Change default shell](./linux/default_shell.md)
- [Zoxide](./linux/zoxide.md) a smarter `cd` command
- [Install Nerd Fonts](./linux/nerd_fonts.md) on Linux using a script
- [timesyncd](./linux/timesyncd.md) a lightweight `ntpd` time sync deamon

## 📄 NeoVim

- [Install NeoVim](./neovim/install-neovim.md)

## 🐚 PowerShell

- [Upgrade Oh My Posh](./powershell/upgrade-oh-my-posh.md)
- [Zoxide](./linux/zoxide.md) a smarter `cd` command

## 🐍 Python

- [HTTP GET and POST](./hacking/pwn.college/talking_web/Readme.md#python)
- [Running external processes](./hacking/pwn.college/progarm_misuse/Readme.md#python)

## 🕹️ Retro Computers

### Commodore 64

- [CCGMS & WiModem](./retro/c64/ccgms.md)
- [JiffyDOS](./retro/c64/jiffy-dos.md)
- [SD2IEC](./retro/c64/SD2IEC.md)
- [Supermon+64 V1.2](./retro/c64/supermod.md)
- [Writing BASIC Files on the Computer and Transferring to the Commodore 64](./retro/c64/tokenize-basic.md)

### CP/M

- [ZDE16](./retro/cpm/zde16.md)

## 📊 SQL

- [Counting in a SQL Select based on the Column Value](./sql/where-in-select.md)

## 🗒️ TypeScript

- [Setup a Yarn Project with TypeScript in VS Code](./typescript/setup-yarn-with-ts.md)

## 🐧 WSL

- [Install WSL2](./wsl/install-wsl.md)
- [Install Desktop and RDP Access in a WSL Distro](./wsl/install-rdp.md)
- [Move WSL to another Drive](./wsl/move_wsl.md)
- [Set the Default User back from Root after Importing WSL Distro](./wsl/set-default-user.md)
- [OpenVPN](./linux/openvpn.md)
- [Connect USB device to WSL](./wsl/usb.md)

## 🪟 Windows

- [Install WinGet](./windows/install-winget.md)

## 🛠️ x86/x64 Assembly

- [x86/x64 Assembly Notes](./hacking/pwn.college/assembly/Readme.md) from [pwn.college](./hacking/pwn.college/Readme.md) course
- [BIOS Interrupts](./x86asm/bios_int.md)
- [Simple HTTP server](./hacking/pwn.college/webserver/server.asm)

## ❓About

I shamelessly stole this idea and format from
[jbranchaud/til](https://github.com/jbranchaud/til).

## 🔗 Other TIL Collections

- [Today I Learned by Hashrocket](https://til.hashrocket.com)
- [jwworth/til](https://github.com/jwworth/til)
- [thoughtbot/til](https://github.com/thoughtbot/til)

## ⚖️ License

&copy; 2024 Rob Prouse

This work is licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. See [LICENSE](.\LICENSE) for details.

![CC BY-NC-SA](./img/by-nc-sa.png)
