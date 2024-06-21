# nmap - Network Mapper

- [nmap](https://nmap.org/)
- [Options summary](https://nmap.org/book/man-briefoptions.html)

```
-p- : This flag scans for all TCP ports ranging from 0-65535
-sV : Attempts to determine the version of the service running on a port
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
