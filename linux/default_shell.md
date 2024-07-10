# Change default shell

To change the default shell for a user,

```sh
chsh -s $(which zsh)
```

Don't use `sudo`, that will change the shell for the `root` user.

You can confirm your shell,

```sh
grep $USER /etc/passwd
```
