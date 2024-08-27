.DEFAULT_GOAL := default

default: run

run: server
        /challenge/run ./server

server: server.o
        ld -o server server.o

server.o: server.asm
        # as -o server.o server.s
		nasm -f elf64 -o server.o server.asm
