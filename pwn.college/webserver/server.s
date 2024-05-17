.intel_syntax noprefix
.globl _start

.section .text

_start:
    # Open then network socket
    # int socket(int domain, int type, int protocol)
    mov rdi, 2                  # AF_INET
    mov rsi, 1                  # SOCK_STREAM
    mov rdx, 0                  # IPPROTO_IP
    mov rax, 0x29
    syscall
    mov [sockfd], rax           # Save the return value

    # Bind the socket to the address
    # int bind(int sockfd, struct sockaddr *addr, socklen_t addrlen)
    mov rdi, [sockfd]           # Return value from socket()
    lea rsi, [rip+sockaddr_in]
    mov rdx, 16
    mov rax, 0x31
    syscall

    # Listen on the socket
    # int listen(int sockfd, int backlog)
    mov rdi, [sockfd]
    mov rsi, 0
    mov rax, 0x32
    syscall

accept:
    # Accept a connection
    # int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
    mov rdi, [sockfd]
    mov rsi, 0
    mov rdx, 0
    mov rax, 0x2B
    syscall
    mov [reqfd], rax

    # Fork a child process to handle the request
    # int fork()
    mov rax, 0x39
    syscall

    # If we are the child process, continue processing the request
    cmp rax, 0
    je process_request

    # If we are the parent process, loop back to accept the next connection
    # Close the socket and go back to accept
    mov rdi, [reqfd]
    mov rax, 0x03
    syscall

    jmp accept

process_request:
    # Close the socket in the child process
    mov rdi, [sockfd]
    mov rax, 0x03
    syscall

    # Read the request
    # ssize_t read(int fd, void *buf, size_t count)
    mov rdi, [reqfd]
    lea rsi, buff
    mov rdx, buff_end-buff-1
    mov rax, 0x00
    syscall

    # Parse out the requested filename from the request
    lea rdi, [rip+buff]      # Load the address of the request string buffer
    call find_space          # Call the find_space function
    mov rsi, rdi             # Save the address of the filename
    call find_space          # Call the find_space function again to find the end of the filename

    # Open the requested file
    # int open(const char *pathname, int flags, mode_t mode)
    mov rdi, rsi                # Filename
    mov rsi, 0                  # O_RDONLY
    mov rdx, 0                  # No mode
    mov rax, 0x02
    syscall
    mov [filefd], rax

    # Read the file into a buffer
    mov rdi, [filefd]
    lea rsi, file_buff
    mov rdx, file_buff_end-file_buff-1
    mov rax, 0x00
    syscall
    mov [file_len], rax      # Save the return value, bytes read

    # Close the file
    mov rdi, [filefd]
    mov rax, 0x03
    syscall

    # Write the response header to the socket
    # ssize_t write(int fd, const void *buf, size_t count);
    mov rdi, [reqfd]
    lea rsi, response
    mov rdx, response_end-response-1
    mov rax, 0x01
    syscall

    # Write the file buffer to the socket
    mov rdi, [reqfd]
    lea rsi, file_buff
    mov rdx, [file_len]
    mov rax, 0x01
    syscall

    # Close the socket
    # int close(int fd)
    mov rdi, [reqfd]
    mov rax, 0x03
    syscall

    # Exit the program
    # void exit(int error_code)
    mov rdi, 0
    mov rax, 0x3C
    syscall

# Function to replace the first space in a string with a null byte
# Entry:
#   rdi: Pointer to the string
# Exit:
#   The first space in the string is replaced with a null byte
#   rdi is incremented to the next character after the space
find_space:
    mov al, [rdi]                # Load the current character into al
    cmp al, ' '                  # Compare the character with space (' ')
    je replace_space             # If it is a space, jump to replace_space
    cmp al, 0                    # Compare the character with null byte ('\0')
    je done                      # If it is null byte, we're done (no space found)
    inc rdi                      # Move to the next character
    jmp find_space               # Repeat the loop

replace_space:
    mov byte ptr [rdi], 0        # Replace the space with a null byte ('\0')
    inc rdi                      # Move to the next character
done:
    ret                          # Return to the caller

.section .data

# The socket returned from socket()
sockfd:
    .8byte  00

# The file descriptor returned from accept()
reqfd:
    .8byte  00

# The file descriptor for the requested file
filefd:
    .8byte  00

# The file length read
file_len:
    .8byte  00

# The address structure passed to bind()
sockaddr_in:
sin_family:
    .2byte  02
sin_port:
    .2byte  0x5000      # Port 80 big endian
sin_addr:
    .4byte  0x00        # 0.0.0.0, 0x7F000001 is 127.0.0.1
pad:
    .8byte  0

# Buffer for the read call
buff:
    .dcb.b 2048
buff_end:

response:
    .string "HTTP/1.0 200 OK\r\n\r\n"
response_end:

# Buffer for the file read and response
file_buff:
    .dcb.b 2048
file_buff_end:
