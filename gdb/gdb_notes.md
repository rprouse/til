# GDB Notes

## .gdbinit

The `~/.gdbinit` file is used to add default commands, breakpoints and user defined commands for GDB sessions. The file can be `~/.config/gdb/gdbinit`, `~/.gdbinit` or `./.gdbinit` for a particular project.

For example,

```sh
set auto-load safe-path /
set disassembly-flavor intel
break main
```

For a more complete option, see [Gdbinit/gdbinit](https://github.com/gdbinit/Gdbinit/blob/master/gdbinit) on GitHub.

## Running a program

For all of the following, append any program arguments to the command. For example, `start <ARGV1> <ARGV2> <ARGVN> < <STDIN_PATH>`.

- `run` runs a program with no breakpoints
- `start` starts a program with a breakpoint on `main`
- `starti` starts a program with a breakpoint on `_start`
- `attach <PID>` to attach to a running program
- `core <PATH>` to analyze a coredump
- `continue` or `c` to continue execution after a breakpoint

## Display registers

- `info registers` to display all registers
- `p $rdi` to print out the value of a register
- `p/x $rdi` to print out the value of a register in hex

## Display memory

- `x/<n><u><f> <address>` where
  - `,n.` is the number of elements to display.
  - `<u>` is the unit size to display. Valid unit sizes are `b` (1 byte), `h` (2 bytes), `w` (4 bytes), and `g` (8 bytes).
  - `<f>` is the format to display the data in. Valid formats are `d` (decimal), `x` (hexadecimal), `s` (string) and `i` (instruction).
  - `<address>` can be specified using a register name, symbol name, or absolute address, and mathematical expressions can be used.
- `disassemble <function>` or `disas <function>` will disassemble an entire funtion. For example, `disas main`.
- When disassembling, you can switch to Intel syntax with `set disassembly-flavor intel`

### Examples

- `x/8i $rip` will print the next 8 instructions from the current instruction pointer.
- `x/16i main` will print the first 16 instructions of main.
- `x/16gx $rsp` will print the first 16 values on the stack.
- `x/gx $rbp-0x32` will print the local variable stored there on the stack.

## Stepping through a program

When stepping through machine instructions, it is useful to first set `display/i $pc` to automatically display the next instruction each time the program stops. You could also use `display/4gx $rsp` to show the next four instructions.

You can also use `layout regs` to put GDB into its TUI mode and show you the contents of all of the registers, as well as nearby instructions.

- `step [count]` or `s` steps to the next source line. This is only useful if the program was compiled with debug information. Count is an optional repeat. It will step into calls.
- `stepi [count]` or `si` steps one machine instruction. Count is an optional repeat. It will step into calls.
- `next [count]` or `n` works like `step` but it will step over function calls.
- `nexti [count]` or `ni` works like `stepi` but it will step over function calls.
- `finish` or `fin` continues until a stack frame returns and prints the return value if any. Think of it as step out.
- `until` or `u` is like `finish` but it is steps out of a loop. I.E. it will not jump back.
- `break *<address>` sets a breakpoint at an address.
