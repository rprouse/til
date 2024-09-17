# Timesyncd

While `ntpd` is the standard for time sync, `timesyncd` is a lighter alternative which is simpler to configure.

To begin, make sure `ntpd` is removed,

```sh
sudo apt purge ntp
```

Then install `timesyncd`,

```sh
sudo apt install systemd-timesyncd
```

and start it,

```sh
sudo systemctl start systemd-timesyncd
sudo systemctl status systemd-timesyncd
```

Finally, check the time,

```sh
timedatectl
```
