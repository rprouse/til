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
    call find_space          # Call the find_space function to jump past the first space
    mov rsi, rdi             # Save the address of the filename to RSI
    call find_space          # Call the find_space function again to find the end of the filename and add a null byte

    # Check if the request is a POST or GET
    lea rdi, [rip+buff]      # Load the address of the request string buffer
    mov al, [rdi]            # Load the first character of the request
    cmp al, 'P'              # Compare the first character with 'P'
    je post                  # If it is 'P', it is a POST request

# GET Request - Open the file and send it back to the client
get:
    # Open the requested file for reading
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

    jmp end_request

# POST Request - Save the file to disk
post:
    # Find the Content-Length header in the request
    # Start by scanning forwards to each newline. This code is not robust and
    # assumes the Content-Length header is present in the request and the last header
    lea rdi, [rip+buff]      # Load the address of the request string buffer

scan_headers:
    call find_newline        # Call the find_newline function to jump past the first newline
    mov al, [rdi]            # Load the current character into al
    cmp al, 'C'              # Compare the character
    jne scan_headers         # If it is not 'C', continue scanning headers
    inc rdi                  # Move to the next character (o)
    inc rdi                  # Move to the next character (n)
    inc rdi                  # Move to the next character (t) for Content-Length or (n) for Connection
    mov al, [rdi]            # Load the current character into al
    cmp al, 't'              # Compare the character
    jne scan_headers         # If it is not 'o', continue scanning headers

    # We assume that a header starting with Cont is Content-Length
    # Find the colon and space after the header
    xor rax, rax        // Clear the file length
    call find_space          # Call the find_space function to jump past the first space

read_content_length:
    mul [file_len], 10       # Multiply the file length by 10
    mov al, [rdi]            # Load the next character into al
    cmp al, '\r'             # Compare the character with carriage return ('\r')
    je done_headers          # If it is a carriage return, we are done with the headers

    sub al, '0'              # Convert the character to a number
    add [file_len], al       # Add the number to the file length

done_headers:
    # Open the requested file for writing
    mov rdi, rsi                # Filename
    mov rsi, 0x201              # O_CREAT | O_WRONLY | O_TRUNC
    mov rdx, 0x1B6              # S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH
    mov rax, 0x02
    syscall
    mov [filefd], rax

    # Write the response header to the socket
    # ssize_t write(int fd, const void *buf, size_t count);
    mov rdi, [reqfd]
    lea rsi, response
    mov rdx, response_end-response-1
    mov rax, 0x01
    syscall

    # Write the file data from the request to the file
    mov rdi, [filefd]
    lea rsi, rbp
    mov rdx, [file_len]
    mov rax, 0x01
    syscall

    # Close the file
    mov rdi, [filefd]
    mov rax, 0x03
    syscall

# Close the request file descriptor and exit the child process
end_request:
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

# Function to jump one past the next \n in a string
# Entry:
#   rdi: Pointer to the string
# Exit:
#   rdi is incremented to the next character after the space
find_newline:
    mov al, [rdi]                # Load the current character into al
    cmp al, '\n'                 # Compare the character with newline ('\n')
    je done                      # If it is a newline finish up
    cmp al, 0                    # Compare the character with null byte ('\0')
    je done                      # If it is null byte, we're done (no newline found)
    inc rdi                      # Move to the next character
    jmp find_newline             # Repeat the loop

done_newline:
    inc rdi                      # Move to the next character
    ret                          # Return to the caller

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

done:
    inc rdi                      # Move to the next character
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
