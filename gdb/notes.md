# GDB Notes

## Running a program

For all of the following, append any program arguments to the command. For example, `start <ARGV1> <ARGV2> <ARGVN> < <STDIN_PATH>`.

- `run` runs a program with no breakpoints
- `start` starts a program with a breakpoint on `main`
- `starti` starts a program with a breakpoint on `_start`
- `attach <PID>` to attach to a running program
- `core <PATH>` to analyze a coredump
- `continue` or `c` to continue execution after a breakpoint

## Displaying registers

- `info registers` to display all registers
- `p $rdi` to print out the value of a register
- `p/x $rdi` to print out the value of a register in hex
