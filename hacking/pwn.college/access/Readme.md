# Access Control

pwn.college [Access Control](https://pwn.college/intro-to-cybersecurity/access-control/) dojo.

## Level 5 - Copy a file without permissions

`/bin/cp` has the SETUID bit set.

```sh
cp --no-preserve=all --remove-destination /flag .
```

## Level 6 - Switch to a group with a password

The flag file is owned by root and a new group. The password for group_qrifecfs is: vpdcmdjm

```sh
newgrp group_qrifecfs
```

## Levels 13 to 19 - Mandatory Access Control

### Levels

- Higher levels can read lower levels
- Lower levels can write higher levels

For example, given,

```python
LEVELS = [Level("TS", 4),
        Level("S", 3),
        Level("C", 2),
        Level("UC", 1)]
```

- TS can read all levels
- UC can only read UC
- UC can write all levels
- TS can write TS

### Categories

```python
CATEGORIES = [
        Category("NUC", 1),
        Category("NATO", 1 << 1),
        Category("ACE", 1 << 2),
        Category("UFO", 1 << 3)
    ]
```

### Code to automate the challenges

```python
#!/usr/bin/env python3

import sys

from pwn import *

class Level:
    def __init__(self, name: str, level: int):
        self.name = name
        self.level = level
    def log(self):
        log.info(F"{self.name}: {self.level}")

class Category:
    def __init__(self, name: str, bit: int):
        self.name = name
        self.bit = bit
    def log(self):
        log.info(F"{self.name}: {self.bit}")

levels = []
categories = []

# Function to find a level or category by name
def get_by_name(objects, name: str):
    for obj in objects:
        if obj.name == name:
            return obj
    return None  # Return None if the name is not found

def get_category_set(cats):
    c = 0
    for cat in cats:
        c1 = get_by_name(categories, cat)
        c |= c1.bit
    return c

def is_subset_equal(a: int, b: int) -> bool:
    return (b | a) == b

def recv_level(run):
    run.recvuntil(b"level ")
    return run.recvuntil(b" ").strip()

def recv_categories(run):
    run.recvuntil(b"categories {")
    result = []
    cats = run.recvuntil(b"}")[:-1].split(b', ')
    for cat in cats:
        cat = cat.strip()
        if len(cat) > 0:
            result.append(cat)

    return result

# Run the challenge using pwntools
run = process(b"/challenge/run")

# Get the number of questions
run.recvuntil(b"to answer ")
s = run.recvuntil(b"questions").strip().decode('ascii').split(' ')
num_questions = int(s[0])
log.info(f"num_questions: {num_questions}")

# Get the number of levels
run.recvuntil(b"system:")
run.recvline()
s = run.recvuntil(b" ").strip()
num_levels = int(s)
run.recvline()

log.info(f"num_levels: {num_levels}")

# Read in the levels
for i in range(num_levels, 0, -1):
    l = run.recvline().strip()
    levels.append(Level(l, i))

for level in levels:
    level.log()

# Read in the number of categories
s = run.recvuntil(b" ").strip()
num_categories = int(s)
run.recvline()

log.info(f"num_categories: {num_categories}")

# Read in the categories
for i in range(0 ,num_categories, 1):
    c = run.recvline().strip()
    categories.append(Category(c, 1 << i))

for category in categories:
    category.log()

# Loop through the questions
for i in range(num_questions):
    # Read in the question subject
    subject_level = recv_level(run)
    subject_categories = recv_categories(run)

    # Read or write?
    run.recv(1)
    rw = run.recvuntil(b" ").strip()
    is_read = rw == b"read"

    # Read in the question object
    object_level = recv_level(run)
    object_categories = recv_categories(run)

    log.info(f"Q{i}: {rw} -> {is_read}")

    # Read until the end of the question
    run.recvline()

    subject = get_by_name(levels, subject_level)

    log.info(b"==subject==")
    subject.log()
    for cat in subject_categories:
        log.info(cat)

    subject_set = get_category_set(subject_categories)

    log.info(f"{subject_set}")

    object = get_by_name(levels, object_level)

    log.info(b"==object==")
    object.log()
    for cat in object_categories:
        log.info(cat)

    object_set = get_category_set(object_categories)

    log.info(f"{object_set}")

    is_allowed_by_level = subject.level >= object.level if is_read else object.level >= subject.level
    is_allowed = False

    if is_allowed_by_level:
        if is_read:
            is_allowed = is_subset_equal(object_set, subject_set)
        else:
            is_allowed = is_subset_equal(subject_set, object_set)

    log.info(F"is_allowed: {is_allowed}")
    if is_allowed:
        run.sendline(b"yes")
    else:
        run.sendline(b"no")

    log.info(run.recvline().strip())

log.info(run.recvall())
```
