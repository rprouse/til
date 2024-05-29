# GDB TUI Mode

[TUI](https://sourceware.org/gdb/current/onlinedocs/gdb.html/TUI.html) (Text User Interface) is a curses based mode that is enabled with the layout command.

## Layout Modes

- `src` displays source and command windows
- `asm` displays disassembly and command windows
- `split` displays source, disassembly and command windows
- ` regs` displays registers and disassembly

## Keyboard Shortcuts

- `CTRL+x,a` enter/leave TUI mode
- `CTRL+x 1` and `CTRL+x 2` use TUI layout with 1 or 2 windows
- `CTRL+x o` change the active window focus
- `CTRL+x s` switch into and out of Single Key mode (see below)
- `CTRL+L` refresh the screen
- Cursor keys and `PgUp`, `PgDn` scroll the active window

## Single Key Mode

Binds frequently used GDB commands to single keys.

- `c` continue
- `C` reverse-continue
- `d` down
- `f` finish
- `F` reverse-finish
- `n` next
- `N` reverse-next
- `o` nexti. The shortcut letter ‘o’ stands for “step Over”.
- `O` reverse-nexti
- `q` exit the SingleKey mode.
- `r` run
- `s` step
- `S` reverse-step
- `i` stepi. The shortcut letter ‘i’ stands for “step Into”.
- `I` reverse-stepi
- `u` up
- `v` info locals
- `w` where
