# nmap - Network Mapper

- [nmap](https://nmap.org/)
- [Options summary](https://nmap.org/book/man-briefoptions.html)

## Probe open ports to determine service/version info

```sh
nmap -sV 10.129.192.208
```

If this doesn't give you the version and other information, you can try running common scripts with -sC,

```sh
nmap -sC 10.129.192.208
```
