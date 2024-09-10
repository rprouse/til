# nmap - Network Mapper

- [nmap](https://nmap.org/)
- [Options summary](https://nmap.org/book/man-briefoptions.html)

## Common options

```txt
-A
-p- : This flag scans for all TCP ports ranging from 0-65535
-p22 : Scan for port 22
-p22-1024 : Scan for ports 22 to 1024
-p U:53,111,137,T:21-25,80,139,8080
-sT : Scan TCP
-sU : Scan UDP
-sN : TCP Null scan
-sV : Attempts to determine the version of the service running on a port
-sC : Equivalent to --script=default, runs scripts against the host
-Pn : Skips host discovery for machines that appear offline
-O : Enable OS detection
-A : Enable OS detection, version detection, script scanning, and traceroute
--min-rate : This is used to specify the minimum number of packets Nmap should send per
second; it speeds up the scan as the number goes higher
```

## Probe open ports to determine service/version info

```sh
nmap -p- --min-rate 1000 -sV 10.129.192.208
```

If this doesn't give you the version and other information, you can try running common scripts with -sC,

```sh
nmap -sC 10.129.192.208
```
