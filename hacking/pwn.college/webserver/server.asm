bits 64

; ==============================================================================
; System call defines
SYS_READ    equ 0x00
SYS_WRITE   equ 0x01
SYS_OPEN    equ 0x02
SYS_CLOSE   equ 0x03
SYS_SOCKET  equ 0x29
SYS_ACCEPT  equ 0x2B
SYS_BIND    equ 0x31
SYS_LISTEN  equ 0x32
SYS_FORK    equ 0x39
SYS_EXIT    equ 0x3C

; Other defines
AF_INET     equ 2
SOCK_STREAM equ 1
IPPROTO_IP  equ 0

O_RDONLY    equ 0
O_WRONLY    equ 1
O_CREAT     equ 0x40

CR          equ 0xD
LF          equ 0xA

; ==============================================================================
; System call macros
; Return value: rax

; ssize_t read(int fd, void *buf, size_t count)
%macro read 3
    mov rdi, [%1]
    mov rsi, %2
    mov rdx, %3
    mov rax, SYS_READ
    syscall
%endmacro

; ssize_t write(int fd, const void *buf, size_t count)
%macro write 3
    mov rdi, [%1]
    mov rsi, %2
    mov rdx, %3
    mov rax, SYS_WRITE
    syscall
%endmacro

; int open(const char *pathname, int flags, mode_t mode)
%macro open 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    mov rax, SYS_OPEN
    syscall
%endmacro

; int close(int fd)
%macro close 1
    mov rdi, [%1]
    mov rax, SYS_CLOSE
    syscall
%endmacro

; int socket(int domain, int type, int protocol)
%macro socket 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    mov rax, SYS_SOCKET
    syscall
%endmacro

; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
%macro accept 3
    mov rdi, [%1]
    mov rsi, %2
    mov rdx, %3
    mov rax, SYS_ACCEPT
    syscall
%endmacro

; int bind(int sockfd, struct sockaddr *addr, socklen_t addrlen)
%macro bind 3
    mov rdi, [%1]
    lea rsi, [rel %2]
    mov rdx, %3
    mov rax, SYS_BIND
    syscall
%endmacro

; int listen(int sockfd, int backlog)
%macro listen 2
    mov rdi, [%1]
    mov rsi, %2
    mov rax, SYS_LISTEN
    syscall
%endmacro

; int fork()
%macro fork 0
    mov rax, SYS_FORK
    syscall
%endmacro

; void exit(int error_code)
%macro exit 1
    mov rdi, %1
    mov rax, SYS_EXIT
    syscall
%endmacro

; ==============================================================================
section .text
global _start
_start:

    ; Open then network socket
    socket AF_INET, SOCK_STREAM, IPPROTO_IP
    mov [sockfd], rax

    ; Bind the socket to the address
    bind sockfd, sockaddr_in, 16

    ; Listen on the socket
    listen sockfd, 0

accept_loop:
    ; Accept a connection
    accept sockfd, 0, 0
    mov [reqfd], rax

    ; Fork a child process to handle the request
    fork

    ; If we are the child process, continue processing the request
    cmp rax, 0
    je process_request

    ; We are the parent process, loop back to accept the next connection
    ; Close the socket and go back to accept
    close reqfd

    jmp accept_loop

process_request:
    ; Close the socket in the child process
    close sockfd

    read reqfd, buff, buff_len

    ; Parse out the requested filename from the request
    lea rdi, [rel buff]      ; Load the address of the request string buffer
    call find_space          ; Call the find_space function to jump past the first space
    mov rsi, rdi             ; Save the address of the filename to RSI
    call find_space          ; Call the find_space function again to find the end of the filename and add a null byte

    ; Check if the request is a POST or GET
    lea rdi, [rel buff]      ; Load the address of the request string buffer
    mov al, byte [rdi]       ; Load the first character of the request
    cmp al, 'P'              ; Compare the first character with 'P'
    je post                  ; If it is 'P', it is a POST request

; ==============================================================================
; GET Request - Open the file and send it back to the client
get:
    ; Open the requested file for reading
    open rsi, O_RDONLY, 0
    mov [filefd], rax

    ; Read the file into a buffer
    read filefd, file_buff, file_buff_len
    push rax                 ; Save the file length

    ; Close the file
    close filefd

    ; Write the response header to the socket
    write reqfd, response, response_len

    ; Write the file buffer to the socket
    pop rax                  ; Load the file length
    write reqfd, file_buff, rax

    ; Close the socket
    close reqfd

    jmp end_request

; ==============================================================================
; POST Request - Save the file to disk
post:
    ; Find the Content-Length header in the request
    ; Start by scanning forwards to each newline. This code is not robust and
    ; assumes the Content-Length header is present in the request and the last header
    lea rdi, [rel buff]      ; Load the address of the request string buffer

scan_headers:
    call find_newline        ; Call the find_newline function to jump past the first newline
    mov al, [rdi]            ; Load the current character into al
    cmp al, 'C'              ; Compare the character
    jne scan_headers         ; If it is not 'C', continue scanning headers
    inc rdi                  ; Move to the next character (o)
    inc rdi                  ; Move to the next character (n)
    inc rdi                  ; Move to the next character (t) for Content-Length or (n) for Connection
    mov al, [rdi]            ; Load the current character into al
    cmp al, 't'              ; Compare the character
    jne scan_headers         ; If it is not 'o', continue scanning headers

    ; We assume that a header starting with Cont is Content-Length
    ; Find the colon and space after the header
    xor rax, rax             ; Clear the file length
    call find_space          ; Call the find_space function to jump past the first space

    mov ax, 0                ; AX will hold the file length until we are done
    mov bx, 0
read_content_length:
    mov bl, [rdi]            ; Load the next character
    cmp bl, CR               ; Compare the character with carriage return ('\r')
    je done_headers          ; If it is a carriage return, we are done with the headers

    imul ax, 10              ; Multiply the file length by 10
    sub bl, '0'              ; Convert the character to a number
    add ax, bx               ; Add the number to the file length
    inc rdi

    jmp read_content_length  ; Read the next digit

done_headers:
    push rax

    inc rdi                  ; Skip the CR after the headers
    inc rdi                  ; Skip the NL after the headers
    inc rdi                  ; Skip the CR after the headers
    inc rdi                  ; Skip the NL after the headers
    mov rbp, rdi             ; Save the address of the file data to RBP

    ; Open the requested file for writing
    open rsi, O_CREAT | O_WRONLY, 0o0777
    mov [filefd], rax

    ; Write the file data from the request to the file
    pop rax
    write filefd, rbp, rax

    ; Close the file
    close filefd

    ; Write the response header to the socket
    write reqfd, response, response_len

; Close the request file descriptor and exit the child process
end_request:
    ; Exit the program
    exit 0

; ==============================================================================
; Function to jump one past the next \n in a string
; Entry:
;   rdi: Pointer to the string
; Exit:
;   rdi is incremented to the next character after the space
find_newline:
    mov al, [rdi]                ; Load the current character into al
    cmp al, LF                   ; Compare the character with newline ('\n')
    je done_newline              ; If it is a newline finish up
    cmp al, 0                    ; Compare the character with null byte ('\0')
    je done_newline              ; If it is null byte, we're done (no newline found)
    inc rdi                      ; Move to the next character
    jmp find_newline             ; Repeat the loop

done_newline:
    inc rdi                      ; Move to the next character
    ret                          ; Return to the caller

; Function to replace the first space in a string with a null byte
; Entry:
;   rdi: Pointer to the string
; Exit:
;   The first space in the string is replaced with a null byte
;   rdi is incremented to the next character after the space
find_space:
    mov al, [rdi]                ; Load the current character into al
    cmp al, ' '                  ; Compare the character with space (' ')
    je replace_space             ; If it is a space, jump to replace_space
    cmp al, 0                    ; Compare the character with null byte ('\0')
    je done                      ; If it is null byte, we're done (no space found)
    inc rdi                      ; Move to the next character
    jmp find_space               ; Repeat the loop

replace_space:
    mov byte [rdi], 0            ; Replace the space with a null byte ('\0')

done:
    inc rdi                      ; Move to the next character
    ret                          ; Return to the caller

; ==============================================================================
section .data

; The address structure passed to bind()
sockaddr_in:
sin_family:
    dw  02
sin_port:
    dw  0x5000      ; Port 80 big endian
sin_addr:
    dd  0x00        ; 0.0.0.0, 0x7F000001 is 127.0.0.1
pad:
    dq  0

response:
    db 'HTTP/1.0 200 OK',CR,LF,CR,LF
response_len equ $-response

; The socket returned from socket()
sockfd:
    dq  0

; The file descriptor returned from accept()
reqfd:
    dq  0

; The file descriptor for the requested file
filefd:
    dq  0
; ==============================================================================
section .bss

; Buffer for the read call
buff:
    resb 2048
buff_len equ $-buff

; Buffer for the file read and response
file_buff:
    resb 2048
file_buff_len equ $-file_buff

