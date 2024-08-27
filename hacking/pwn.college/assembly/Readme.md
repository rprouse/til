# Assembly Crash Course

pwn.college [Assembly Crash Course](https://pwn.college/fundamentals/assembly-crash-course/) dojo.

## GNU Assembler - GAS

The dojo specifies using `as` to work through the exercises using Intel format.

The base `asm.s` file should look like this,

```assembly
.intel_syntax noprefix

.global _start

.text
_start:
    mov rdi, 0x1337
```

To assemble and submit it for the exercises,

```sh
as -o asm.o asm.s
objcopy -O binary --only-section=.text ./asm.o ./asm.bin
cat ./asm.bin | /challenge/run
```

## NASM

I prefer using [NASM]() for x86 assembly.

The base `asm.asm` file should look like this,

```assembly
bits 64
section .text

_start:
    mov rdi, 0x1337
```

To assemble and submit it for the exercises,

```sh
nasm -f bin -o asm.bin asm.asm
cat ./asm.bin | /challenge/run
```

## Registers

| 64-bit register | Lowest 32-bits | Lowest 16-bits | 2nd Lowest 8-bits | Lowest 8-bits |
| --------------- | -------------- | -------------- | ----------------- | ------------- |
| rax             | eax            | ax             | ah                | al            |
| rbx             | ebx            | bx             | bh                | bl            |
| rcx             | ecx            | cx             | ch                | cl            |
| rdx             | edx            | dx             | dh                | dl            |
| rsi             | esi            | si             |                   | sil           |
| rdi             | edi            | di             |                   | dil           |
| rbp             | ebp            | bp             |                   | bpl           |
| rsp             | esp            | sp             |                   | spl           |
| r8              | r8d            | r8w            |                   | r8b           |
| r9              | r9d            | r9w            |                   | r9b           |
| r10             | r10d           | r10w           |                   | r10b          |
| r11             | r11d           | r11w           |                   | r11b          |
| r12             | r12d           | r12w           |                   | r12b          |
| r13             | r13d           | r13w           |                   | r13b          |
| r14             | r14d           | r14w           |                   | r14b          |
| r15             | r15d           | r15w           |                   | r15b          |

## Flag Registers

| Name | Symbol | Bit | Use |
| --- | --- | --- | --- |
| Carry | CF | 0 | Used to indicate if the previous operation resulted in a carry. |
| Parity | PF | 2 | Used to indicate if the last byte has an even number of 1's (i.e., even parity). |
| Adjust | AF | 4 | Used to support Binary Coded Decimal operations. |
| Zero | ZF | 6 | Used to indicate if the previous operation resulted in a zero result. |
| Sign | SF | 7 | Used to indicate if the result of the previous operation resulted in a 1 in the most significant bit (indicating negative in the context of signed data). |
| Direction | DF | 10 | Used to specify the direction (increment or decrement) for some string operations. |
| Overflow | OF | 11 | Used to indicate if the previous operation resulted in an overflow. |

## Memory Sizes

| Size | NASM | Bytes | Bits |
| --- | --- | --- | --- |
| Quad Word | dq | 8 Bytes | 64 bits |
| Double Word | dd | 4 bytes | 32 bits |
| Word        | dw | 2 bytes | 16 bits |
| Byte        | db | 1 byte  | 8 bits |

In x86_64, you can access each of these sizes when dereferencing an address, just like using
bigger or smaller register accesses:

| Instruction | Description |
| --- | --- |
| mov al, [address]  | moves the least significant byte from address to rax |
| mov ax, [address]  | moves the least significant word from address to rax |
| mov eax, [address] | moves the least significant double word from address to rax |
| mov rax, [address] | moves the full quad word from address to rax |

## 📖 Further Reading

- An awesome intro series that covers some of the fundamentals from [LiveOverflow](https://www.youtube.com/watch?v=iyAyN3GFM7A&list=PLhixgUqwRTjxglIswKp9mpkfPNfHkzyeN&index=1).
- A [`Ike: The Systems Hacking Handbook](https://ike.mahaloz.re/1_introduction/introduction.html), an excellent guide to Computer Organization.
- A [comprehensive assembly tutorial](https://github.com/mytechnotalent/Reverse-Engineering-Tutorial) for several architectures (amd64 is the relevant one here).
- The course ["Architecture 1001: x86-64 Assembly"](https://ost2.fyi/Arch1001) from OpenSecurityTraining2.
- A whole [x86_64 assembly book](https://open.umn.edu/opentextbooks/textbooks/733) to help you out!
- A [game](https://squallygame.com/) to teach you x86 assembly and one to [stress test your knowledge](https://oooverflow.io/zero-is-you/)!
- A [flowchart](https://soc.me/interfaces/x86-prefixes-and-escape-opcodes-flowchart) of x86 prefix and escape opcodes.
- An unofficial, but extremely detailed and useful [x86 reference](https://www.felixcloutier.com/x86/).
