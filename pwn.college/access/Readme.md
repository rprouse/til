# Access Control

pwn.college [Access Control](https://pwn.college/intro-to-cybersecurity/access-control/) dojo.

## Level 5 - Copy a file without permissions

`/bin/cp` has the SETUID bit set.

```sh
cp --no-preserve=all --remove-destination /flag .
```
