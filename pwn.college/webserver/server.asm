section .text
global _start
_start:
    mov rdi, 0
    mov rax, 60     ; SYS_exit
    syscall
    
section .data
