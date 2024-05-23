# BIOS Interrupts

- [BIOS interrupt call - Wikipedia](https://en.wikipedia.org/wiki/BIOS_interrupt_call)
- [INT 10H - Wikipedia](https://en.wikipedia.org/wiki/INT_10H)
- [BIOS - OSDev Wiki](https://wiki.osdev.org/BIOS)

BIOS interupts only work when the processor is still in 16-bit mode.

```asm
mov ah, 0x0e ; int 10/ah = 0eh -> scrolling teletype BIOS routine
mov al, ’H’  ; the character to output
int 0x10     ; call out to the interupt
```
