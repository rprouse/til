# Connect USB device to WSL

For WiFI drivers, you may need to [Recompile the Linux Kernel](./kernel.md).

Install `usbipd`,

```sh
winget install --interactive --exact dorssel.usbipd-win
```

List USB devices,

```sh
usbpid list
```

Get the BUSID of the device you want to use and `bind` it as admin, then list again to make sure it is shared.

```sh
gsudo usbipd bind --busid 2-17
usbpid list
```

Now `attach` to the device,

```sh
usbipd attach --wsl --busid 2-17 --distribution kali
```

In WSL, you should now see the device with `lsusb`.

Once you are done with it, `detach` from the device,

```sh
usbipd detach --busid 2-17
```
