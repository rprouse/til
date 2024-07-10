# Zoxide

[Zoxide](https://github.com/ajeetdsouza/zoxide) is a smarter `cd` command that remembers which directories you use so you can jump to them in just a few keystrokes.

Include [fzf](https://github.com/junegunn/fzf#installation) a command-line fuzzy finder which will add an interactive `cdi` command or allow you to type `cd src [SPACE][TAB]` to autocomplete.

## Install

### Windows PowerShell

```sh
winget install ajeetdsouza.zoxide
winget install fzf
```

Add to `Profile.ps1`

```powershell
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
```

### Linux ZSH

```sh
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
sudo apt update
sudo apt install fzf
```

Add to the end of `.zshrc`

```sh
eval "$(zoxide init --cmd cd zsh)"
```
