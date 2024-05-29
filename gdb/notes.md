# GDB Notes

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
