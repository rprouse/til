# Building a Web Server

Develop the skills needed to build a web server from scratch, starting with a simple program and progressing to handling multiple HTTP GET and POST requests. The server is written in assembly using the [GNU Assembler](https://sourceware.org/binutils/docs/as/) using Intel Syntax.

## Code

- [Makefile](./Makefile)
- [server.s](./server.s) GNU Assembler (GAS) version
- [server.asm](./server.asm) NASM version

## Notes

### Level 9

The GET request is in the form,

```txt
GET /tmp/tmplfy_on1j HTTP/1.1\r\nHost: localhost\r\nUser-Agent: python-requests/2.31.0\r\nAccept-Encoding: gzip, deflate, zstd\r\nAccept: */*\r\nConnection: keep-alive\r\n\r\n
```

```sh
curl http://localhost/etc/issue
```

Normalized,

```txt
GET /tmp/tmplfy_on1j HTTP/1.1
Host: localhost
User-Agent: python-requests/2.31.0
Accept-Encoding: gzip, deflate, zstd
Accept: */*
Connection: keep-alive
```

### Level 10

The POST request is in the form

```txt
POST /tmp/tmp_lujmq8s HTTP/1.1\r\nHost: localhost\r\nUser-Agent: python-requests/2.31.0\r\nAccept-Encoding: gzip, deflate, zstd\r\nAccept: */*\r\nConnection: keep-alive\r\nContent-Length: 106\r\n\r\nluxCpwzQX11ZXl4ASUNdK8gPozVzNKZTnVVdeynQP6YiGHp1IZOIt5PggTzf8VqqDMc3xARQ19L9yCiasFYyQJykvOnczTiqVaMfpz3JHl
```

```sh
curl -d "luxCpwzQX11ZXl4ASUNdK8gPozVzNKZTnVVdeynQP6YiGHp1IZOIt5PggTzf8VqqDMc3xARQ19L9yCiasFYyQJykvOnczTiqVaMfpz3JHl" -X POST http://localhost/tmp/mypost
```

Normalized,

```txt
POST /tmp/tmp_lujmq8s HTTP/1.1
Host: localhost
User-Agent: python-requests/2.31.0
Accept-Encoding: gzip, deflate, zstd
Accept: */*
Connection: keep-alive
Content-Length: 106

luxCpwzQX11ZXl4ASUNdK8gPozVzNKZTnVVdeynQP6YiGHp1IZOIt5PggTzf8VqqDMc3xARQ19L9yCiasFYyQJykvOnczTiqVaMfpz3JHl
```

## Useful links

- pwn.college [Building a Web Server](https://pwn.college/intro-to-cybersecurity/building-a-web-server/) module
- [x86 and amd64 instruction reference](https://www.felixcloutier.com/x86/)
- [x64 syscalls](https://x64.syscall.sh/)
- [x86 Assembly](https://en.wikibooks.org/wiki/X86_Assembly) wikibook
