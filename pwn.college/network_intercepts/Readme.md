# Intercepting Communication

Learn various techniques to intercept and manipulate network communication, from connecting to remote hosts to performing man-in-the-middle attacks.

pwn.college [Intercepting Communication](https://pwn.college/intro-to-cybersecurity/intercepting-communication/)

## Listen to a port

The simplest method is to use netcat,

```sh
nc -l 31337
```

But I first did it with a C program,

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define BUFFER_SIZE 1024

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int port = atoi(argv[1]);
    if (port <= 0) {
        fprintf(stderr, "Invalid port number\n");
        exit(EXIT_FAILURE);
    }

    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[BUFFER_SIZE] = {0};

    // Creating socket file descriptor
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    // Forcefully attaching socket to the port
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        perror("setsockopt");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(port);

    // Bind the socket to the port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    // Listen for incoming connections
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port %d\n", port);

    // Accept an incoming connection
    if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
        perror("accept");
        close(server_fd);
        exit(EXIT_FAILURE);
    }

    // Receive data and print it
    int read_bytes;
    while ((read_bytes = read(new_socket, buffer, BUFFER_SIZE)) > 0) {
        printf("%.*s", read_bytes, buffer);
        memset(buffer, 0, BUFFER_SIZE);
    }

    if (read_bytes < 0) {
        perror("read");
    }

    // Close the connection
    close(new_socket);
    close(server_fd);

    return 0;
}
```

Compile the program with `gcc -o tcp_server tcp_server.c`

## Find a host on a network

In this challenge you will find and connect to a remote host. The remote host is somewhere on the `10.0.0.0/24` subnetwork, listening on port `31337`.

```sh
nmap -v -p 31337 10.0.0.0/24
nc 10.0.0.98 31337
```

## Find a hosts that are up on a large network

```sh
nmap -v --open -T4 -sn 10.0.0.0/16
```

 This took 2572 seconds. Others solve in less than two minutes so there is a quicker way to scan. 🤔
