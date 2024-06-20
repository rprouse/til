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
