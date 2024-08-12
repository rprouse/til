# Cracking WiFi Passwords with aircrack-ng

In order to crack WPA2-PSK2, you will need an adapter that can be put into Monitor mode. Most internal WiFi adapters cannot, so you will likely need a USB adapter. I use an [Alfa AUS036ACM](https://amzn.to/4dHXJ62) which works out of the box with Kali Linux. You can also view the full list of [supported adapters](https://www.aircrack-ng.org/doku.php?id=compatible_cards).

`lsusb` will show you connected USB devices. `ip a` or `ifconfig` will show you adapters. Finally `iwconfig` will show you WiFi adapters and whether or not they are in Monitor mode.
