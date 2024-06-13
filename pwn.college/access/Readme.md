# Access Control

pwn.college [Access Control](https://pwn.college/intro-to-cybersecurity/access-control/) dojo.

## Level 5 - Copy a file without permissions

`/bin/cp` has the SETUID bit set.

```sh
cp --no-preserve=all --remove-destination /flag .
```

## Level 6 - Switch to a group with a password

The flag file is owned by root and a new group. The password for group_qrifecfs is: vpdcmdjm

```sh
newgrp group_qrifecfs
```
