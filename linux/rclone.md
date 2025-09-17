# Mount Google Drive on Linux using Rclone
## Install
```sh
sudo apt install rclone
```

## Configure
```sh
rclone config
```

This will launch the configuration wizard. Add a New Remote for Google Drive.

## Mount Google Drive
Create a `~/gdrive` directory to mount, then,

```sh
rclone mount GDrive: ~/gdrive
```

## Automatically Mount on Startup

```sh
(crontab -l 2>/dev/null; echo "@reboot rclone mount GDrive: $HOME/gdrive") | crontab -
```
