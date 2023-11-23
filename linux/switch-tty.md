# Switch to Virtual Consoles (TTYs)

To switch from the GUI desktop in Linux, you can use `CTRL+ALT+F1` to switch to
`tty1`. Use `F1` through `F6` to access `tty1` through `tty6`.

Once you are in a `tty` virtual console, you can just use `ALT+Fn` to switch
between the six consoles. The logged in GUI desktop is on `tty7`(1) so you can
get back to X-Windows with `ALT+F7`.

**(1)** - At least on my Raspberry Pi. I have read that newer versions of Ubuntu
use `tty1` and `tty2` for the login screen and user desktop respectively.
