# Running a Container

## Running Detached

```sh
docker run -d -p 9999:8888 myhello
```

## Running Interactive

```sh
docker run -i -t fedora
```

- `-p HOST_PORT:CONTAINER_PORT` Forward the port to the host
- `-d` Run detached
- `-i` Run interactive
- `-t` Allocate a pseudo-TTY
