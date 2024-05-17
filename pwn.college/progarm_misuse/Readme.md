# Program Misuse

pwn.college [Program Misuse](https://pwn.college/fundamentals/program-misuse/) dojo.

## Run a process without environment variables

```sh
env -i hello
```

## Python

### Run external process in Python

```python
import subprocess

subprocess.run(['/challenge/embryoio_level16'])
```

### Run external process in Python and redirect file to stdin

```python
import sys
import subprocess

with open('/tmp/qymjzu', 'r') as infile:
    subprocess.Popen(['/challenge/embryoio_level19'],
        stdin=infile, stdout=sys.stdout, stderr=sys.stderr)
```

### Run external process in Python and redirect output to stdout

```python
import sys
import subprocess

with open('/tmp/qymjzu', 'w+') as outfile:
    subprocess.Popen(['/challenge/embryoio_level19'],
        stdin=sys.stdin, stdout=outfile, stderr=sys.stderr)
```

## C Program to fork off a child process

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/wait.h>

void pwncollege(int argc, char *argv[])
{
    pid_t pid = fork();
    if (pid == -1)
    {
        perror("Failed to fork");
    }
    else if (pid > 0)
    {
        // We are the parent
        int status;
        waitpid(pid, &status, 0);
    }
    else
    {
        execve("/challenge/embryoio_level31", &argv[1], NULL);
        _exit(EXIT_FAILURE);   // exec never returns
    }
}

void main(int argc, char *argv[])
{
    pwncollege(argc, argv);
}
```

## level48

```python
import subprocess

p2 = subprocess.Popen(['grep', 'pwn'], stdin=subprocess.PIPE, stdout=subprocess.PIPE)

p1 = subprocess.Popen(['/challenge/embryoio_level49'], stdin=subprocess.PIPE, stdout=p2.stdin)

p2.communicate()
```

## Search line using sed and print it

```sh
sed -n '/pwn/p'
```
