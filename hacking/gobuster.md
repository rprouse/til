# Gobuster

[Gobuster](https://github.com/OJ/gobuster) is a tool used to brute-force:

- URIs (directories and files) in web sites.
- DNS subdomains (with wildcard support).
- Virtual Host names on target web servers.
- Open Amazon S3 buckets
- Open Google Cloud buckets
- TFTP servers

```sh
$ gobuster dir -e -u http://10.129.105.239/ -w /usr/share/wordlists/dirb/common.txt -x php
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.129.105.239/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.6
[+] Extensions:              php
[+] Expanded:                true
[+] Timeout:                 10s
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
http://10.129.105.239/.php                 (Status: 403) [Size: 279]
http://10.129.105.239/.hta                 (Status: 403) [Size: 279]
http://10.129.105.239/.hta.php             (Status: 403) [Size: 279]
http://10.129.105.239/.htpasswd.php        (Status: 403) [Size: 279]
http://10.129.105.239/.htpasswd            (Status: 403) [Size: 279]
http://10.129.105.239/.htaccess            (Status: 403) [Size: 279]
http://10.129.105.239/.htaccess.php        (Status: 403) [Size: 279]
http://10.129.105.239/assets               (Status: 301) [Size: 317] [--> http://10.129.105.239/assets/]
http://10.129.105.239/config.php           (Status: 200) [Size: 0]
http://10.129.105.239/css                  (Status: 301) [Size: 314] [--> http://10.129.105.239/css/]
http://10.129.105.239/dashboard            (Status: 301) [Size: 320] [--> http://10.129.105.239/dashboard/]
http://10.129.105.239/fonts                (Status: 301) [Size: 316] [--> http://10.129.105.239/fonts/]
http://10.129.105.239/index.html           (Status: 200) [Size: 58565]
http://10.129.105.239/js                   (Status: 301) [Size: 313] [--> http://10.129.105.239/js/]
http://10.129.105.239/login.php            (Status: 200) [Size: 1577]
http://10.129.105.239/logout.php           (Status: 302) [Size: 0] [--> login.php]
http://10.129.105.239/server-status        (Status: 403) [Size: 279]
Progress: 9228 / 9230 (99.98%)
===============================================================
Finished
===============================================================
```
