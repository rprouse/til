# Install NeoVim

[Installing NeoVim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

## Windows

```sh
winget install --id BurntSushi.ripgrep.MSVC
winget install Neovim.Neovim
```

## Raspberry Pi

```sh
sudo apt install snapd
sudo snap install --classic nvim
```

Will be in path `/snap/bin/nvim`

## Linux

The apt version on Ubuntu is way out of date. Download from GitHub.

```sh
sudo apt install libfuse2 ripgrep
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
mkdir bin
mv nvim.appimage bin/nvim
```

Add `bin` to path and alias `nvim`

```sh
alias vi=nvim
alias vim=nvim
```
