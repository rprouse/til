.DEFAULT_GOAL := default

default: run

run: server
        /challenge/run ./server

server: server.o
        ld -o server server.o

server.o: server.s
        as -o server.o server.s
