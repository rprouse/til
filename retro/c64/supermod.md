# Supermon+64 V1.2

Supermon64 is a machine-language monitor for the Commodore 64 originally written by Jim Butterfield.

The following was taken from the instructions at [jblang/supermon64](https://github.com/jblang/supermon64).

## Usage Instructions

### Number Bases

| Prefix | Base    |
| ------ | ------- |
| $      | Hex     |
| +      | Decimal |
| &      | Octal   |
| %      | Binary  |

### Overview

- `g`  go (run)
- `j`  jump  (subroutine)
- `l`  load from tape or disk
- `m`  memory display
- `r`  register display
- `s`  save to tape or disk
- `x`  exit to basic
- `a`  simple assembler
- `d`  disassembler
- `f`  fill memory
- `h`  hunt memory
- `t`  transfer memory
- `c`  compare memory
- `@`  disk status/command

### Number Conversion

```sh
$2000
      $2000
      +8192
      &20000
      %10000000000000
```

In the above example the user has asked for the numeric
equivalents to hexadecimal 2000.  The reply shows the value in hex
`$`, in decimal `+`, in octal `&` and in binary `%`.

The user could ask for a number to be converted from any of these
bases by giving the appropriate prefix.

IMPORTANT NOTE -- At any time in the following text, you may enter
any number in any base and conversion will be done for you.

Example:

```sh
m +4096
```

Will cause a memory display from decimal address 4096. In the
display, the hex address ($1000) will be shown. Similarly,

```sh
+2048 lda#%10000000
```

Will be converted to assemble: "a $0400 lda #$80"

If you don't give a prefix, the monitor will assume hexadecimal.

### Register Display

```sh
r

   pc  sr ac xr yr sp
; 0000 01 02 03 04 05
```

Displays the register values saved when SUPERMON+ was entered.
Values may be changed by typing over the display followed by a
return character.

pc - program counter
sr - status register
ac, xr, yr - a, x, and y registers
sp - stack pointer

### Memory Display

```sh
m 200 209

>0200 4d 20 32 30 30 20 32 30: m 200 20
>0208 39 00 00 04 00 04 00 04: 9.......
```

Display memory from 0200 hex to 0209 hex. Display is in lines of
8, so addresses $200 to $20f are shown. If only one address is
used then 12 lines (96 locations) will be shown. If no address is
given display will go from the last address. Equivalent ASCII
characters are shown in reverse at the right. Values are changed
by typing over the display followed by a return character.

### Exit to BASIC

```sh
x
```

Return to BASIC READY mode. When you wish to return to SUPERMON+,
command "SYS 8".

### Simple Assembler

```sh
a 2000 lda #+18
```

changes  to:

```sh
a 2000 a9 12    lda #$12
a 2002  ..next instruction
```

In the above example the user started assembly at 2000 hex. The
first instruction was load a register with immediate 18
decimal. In following lines the user need not type the "a" and
address. The simple assembler prompts with the next address. To
exit the assembler type a return after the the address prompt.

Previous lines may be changed by typing over the right hand part.

### Disassembler

```sh
d 2000 2004

. 2000 a9 12    lda #$12
. 2002 9d 00 80 sta $8000,x
```

Disassembles instructions from 2000 to 2004 hex. If one address
is given, 20 bytes will be disassembled. If no address,
start from the last used address.

Code may be reassembled by moving the cursor back and typing over
the right hand part.

### Fill Memory

```sh
f 1000 1100 ff
```

fills the memory from 1000 hex to 1100 hex with the byte ff hex.

### Go (run)

```sh
g 1000
```

Go to address 1000 hex and begin running code. If no address is
given, the address from the `pc` register is used.

### Jump (subroutine)

```sh
j 1000
```

Call address 1000 hex and begin running code. Return to the
monitor.

### Hunt Memory

```sh
h c000 d000 'read
```

Hunt thru memory from c000 hex to d000 hex for the ascii string
"read" and print the address where it is found. A maximum of
32 characters may be used.

```sh
h c000 d000 20 d2 ff
```

Hunt memory from c000 hex to d000 hex for the sequence of bytes
20 d2 ff and print the address. A maximum of 32 bytes may be used.

### File Handling

#### Load

```sh
l
```

Load any program from cassette #1.

```sh
l "ram test"
```

Load from cassette #1 the program named "ram test".

```sh
l "ram test",08
```

Load from disk (device 8) the program named  "ram test". This
command leaves basic pointers unchanged.

#### Save

```sh
s "program name",01,0800,0c80
```

Save to cassette #1 memory from 0800 hex up to but not including
0c80 hex and name it "program name".

```sh
s "0:program name",08,1200,1f50
```

Save to disk drive #0 memory from 1200 hex up to but not including
1f50 hex and name it "program name".

### Transfer Memory

```sh
t 1000 1100 5000
```

Transfer memory in the range 1000 hex to 1100 hex and start storing
it at address 5000 hex.

### Compare Memory

```sh
c 1000 1100 5000
```

Compare memory in the range 1000 hex to 1100 hex with memory
starting at address 5000 hex.

### Disk Operations

```sh
@
```

Get disk status message

```sh
@9
```

Get disk unit 9 status message

```sh
@,$0
```

Get drive 0 directory

```sh
@,s0:temp
```

Scratch file 'temp' from disk

### Output to Printer

Call SUPERMON+ from basic with:

```sh
open 4,4:cmd 4:sys 8
```

All commands will go the printer.  When complete, return to basic
with "x" and command:

```sh
print#4:close 4
```

### Restarting Supermon

Supermon will load itself into the top of memory...wherever that happens to
be on your machine. Be sure to note the SYS command which links SUPERMON
to the Commodore. It may be used to reconnect the monitor if it is
accidentally disconnected by use of the run-stop/restore keys.
