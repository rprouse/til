# Compile latest Linux kernel for WSL2

In order to use a [USB WiFi card](./usb.md), you need to compile them into the Linux kernel.

## Install build tools

```sh
sudo apt update
sudo apt install -y \
    build-essential flex bison \
    libgtk-3-dev libelf-dev libncurses-dev autoconf \
    libudev-dev libtool zip unzip v4l-utils libssl-dev \
    python3-pip cmake git iputils-ping net-tools dwarves \
    guvcview python-is-python3 bc
```

## Clone the Linux kernel

```sh
cd ~/src
git clone https://github.com/microsoft/WSL2-Linux-Kernel.git wsl2-kernel
```

## Configure the kernel

```sh
cd ~/src/wsl2-kernel
cp Microsoft/config-wsl .config
make menuconfig
```

Under `Device Drivers -> Network device support -> Wireless LAN`, enable the WiFi drivers you need and save the configuration.

## Build the kernel and install modules

```sh
make -j$(nproc)
sudo make modules_install headers_install
cp arch/x86_64/boot/bzImage /mnt/d/wsl
```

## Build the USBIP tools

```sh
cd tools/usb/usbip
./autogen.sh
./configure
make -j$(nproc)
sudo make install
```

## Install the custom kernel

Exit and shutdown WSL2 with `wsl --shutdown`. Then create/edit a file `.wslconfig` in your Windows user directory.

```ini
[wsl2]
kernel=d:\\wsl\\bzImage
```

Start a new WSL session and check the kernel,

```sh
$> uname -r
6.6.36.3-microsoft-standard-WSL2+
```

## Drivers

The following are as yet unsuccessful attempts to get WiFi drivers working.

```sh
sudo apt update
sudo apt install firmware-misc-nonfree
```

```sh
sudo modprobe vhci_hcd
sudo modprobe mt76x2u
lsmod
```
