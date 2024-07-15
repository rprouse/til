# Move WSL to another Drive

Determine the names of the distros on your machine,

```sh
$ wsl --list -v
  NAME                   STATE           VERSION
* Ubuntu                 Running         2
  Kali                   Stopped         2
  docker-desktop         Running         2
  docker-desktop-data    Running         2
```

Stop WSL to be safe. If Docker displays a warning, ignore it for now.

```sh
wsl --shutdown
```

Export the distro to a `.tar` file,

```sh
wsl --export Ubuntu d:\ubuntu.tar
```

Delete the distro on the original drive

```sh
wsl --unregister Ubuntu
```

Import the distro to the new drive

```sh
mkdir D:\WSL
wsl --import Ubuntu D:\WSL\Ubuntu d:\ubuntu.tar
```

If necessary, set the distro back to the default,

```sh
wsl -s Ubuntu
```

When you export a WSL distro then import it, the default user is switched to the `root` user. To switch it back to your user, follow the instructions [Set the Default User back from Root after Importing WSL Distro](./set-default-user.md).
