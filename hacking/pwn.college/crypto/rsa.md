# RSA (Rivest-Shamir-Adleman) Asymmetric Encryption

In math, they symbol ≡ means identical to. ϕ is phi from Euler's theorum.

## RSA Key Generation

1. Choose two large prime numbers `p` and `q`
2. Compute `n = pq`
3. Compute phi of n `ϕ(n) = (p-1)(q-1)`
4. Choose `e` such that `gcd(e, ϕ(n)) = 1 (coprime)`
   - The most common value for `e` is `0x10001` or `65537`
5. Compute `d ≡ e^-1`

```python
from Crypto.PublicKey import RSA
key = RSA.generate(2048)
```

## RSA Encryption

`c ≡ m^e (mod n)`

where

- `m` is plaintext
- `c` is ciphertext
- `d` is the private key component
- `n` is key modulus

```python
assert len(ciphertext) <= 256
message = pow(int.from_bytes(, "little"), key.e, key.n).to_bytes(256, "little")
```

## RSA Decryption

`m ≡ c^d (mod n)`

where

- `m` is plaintext
- `c` is ciphertext
- `e` is the public key component
- `n` is key modulus

```python
assert len(message) <= 256
ciphertext = pow(int.from_bytes(message, "little"), d, n).to_bytes(256, "little")
```

## Level 7 - RSA Decryption

In this challenge you will decrypt a secret encrypted with RSA (Rivest–Shamir–Adleman). You will be provided with both the public key and private key.

```python
#!/usr/bin/env python3

import sys
import base64

from pwn import *

def show(name, value, *, b64=True):
    log.info(f"{name}: {value}")

def show_b64(name, value):
    show(f"{name} (b64)", base64.b64encode(value).decode())

def show_hex(name, value):
    show(name, hex(value))

# Run the challenge using pwntools
run = process(b"/challenge/run")

# Read the RSA public exponent e
run.recvuntil(b"e: ")
estr = run.recvline().strip();
e = int(estr, 16)
show_hex("e", e)

# Read the RSA private exponent d
run.recvuntil(b"d: ")
dstr = run.recvline().strip();
d = int(dstr, 16)
show_hex("d", d)

# Read the RSA modulus
run.recvuntil(b"n: ")
nstr = run.recvline().strip();
n = int(nstr, 16)
show_hex("n", n)

# Read the Base64 encoded secret
run.recvuntil(b"secret ciphertext (b64): ")
secretb64 = run.recvline().strip();
secret = base64.b64decode(secretb64)
show_b64("secret", secret)

# Decrypt the RSA encrypted message
plaintext = pow(int.from_bytes(secret, "little"), d, n).to_bytes(256, "little")
log.info(plaintext)
```

## Level 8 - RSA Decryption with the prime factors

In this challenge you will decrypt a secret encrypted with RSA (Rivest–Shamir–Adleman). You will be provided with the prime factors of n.

```python
#!/usr/bin/env python3

import sys
import base64

from pwn import *

def show(name, value, *, b64=True):
    log.info(f"{name}: {value}")

def show_b64(name, value):
    show(f"{name} (b64)", base64.b64encode(value).decode())

def show_hex(name, value):
    show(name, hex(value))

# Run the challenge using pwntools
run = process(b"/challenge/run")

# Read the RSA public exponent e
run.recvuntil(b"e: ")
estr = run.recvline().strip();
e = int(estr, 16)
show_hex("e", e)

# Read the first factor of the RSA modulus p
run.recvuntil(b"p: ")
pstr = run.recvline().strip();
p = int(pstr, 16)
show_hex("p", p)

# Read the second factor of the RSA modulus q
run.recvuntil(b"q: ")
qstr = run.recvline().strip();
q = int(qstr, 16)
show_hex("q", q)

# Read the Base64 encoded secret
run.recvuntil(b"secret ciphertext (b64): ")
secretb64 = run.recvline().strip();
secret = base64.b64decode(secretb64)
show_b64("secret", secret)

# Compute d and n
n = p * q
phi = (p-1)*(q-1)
d = pow(e, -1, phi)

# Decrypt the RSA encrypted message
plaintext = pow(int.from_bytes(secret, "little"), d, n).to_bytes(256, "little")
log.info(plaintext)
```

## Level 11 - RSA Challenge-Response

In this challenge you will complete an RSA challenge-response. You will be provided with both the public key and private key.

```python
#!/usr/bin/env python3

import sys

from pwn import *

def show(name, value, *, b64=True):
    log.info(f"{name}: {value}")

def show_hex(name, value):
    show(name, hex(value))

# Run the challenge using pwntools
run = process(b"/challenge/run")

# Read the RSA public exponent e
run.recvuntil(b"e: ")
estr = run.recvline().strip();
e = int(estr, 16)
show_hex("e", e)

# Read the RSA private exponent d
run.recvuntil(b"d: ")
dstr = run.recvline().strip();
d = int(dstr, 16)
show_hex("d", d)

# Read the RSA modulus
run.recvuntil(b"n: ")
nstr = run.recvline().strip();
n = int(nstr, 16)
show_hex("n", n)

# Read the challenge
run.recvuntil(b"challenge: ")
challengestr = run.recvline().strip();
challenge = int(challengestr, 16)
show_hex("challenge", challenge)

# Calculate and send the response
response = pow(challenge, d, n)
run.recvuntil(b"response: ")
run.sendline(hex(response))

# Pwn the flag
log.info(run.recvall())
```

## Level 12 - RSA Encryption/Decryption with key exchange

In this challenge you will complete an RSA challenge-response. You will provide the public key.

```python
#!/usr/bin/env python3

import sys
import base64

from Crypto.PublicKey import RSA

from pwn import *

def show(name, value, *, b64=True):
    log.info(f"{name}: {value}")

def show_b64(name, value):
    show(f"{name} (b64)", base64.b64encode(value).decode())

def show_hex(name, value):
    show(name, hex(value))

# Run the challenge using pwntools
run = process(b"/challenge/run")

# Generate and send the key
key = RSA.generate(1024)

run.recvuntil(b"e: ")
run.sendline(hex(key.e).encode('ascii'))
run.recvuntil(b"n: ")
run.sendline(hex(key.n).encode('ascii'))

# Read the challenge
run.recvuntil(b"challenge: ")
challengestr = run.recvline().strip();
challenge = int(challengestr, 16)
show_hex("challenge", challenge)

# Calculate and send the response
response = pow(challenge, key.d, key.n)
run.recvuntil(b"response: ")
run.sendline(hex(response).encode('ascii'))

# Pwn the flag
run.recvuntil(b"(b64): ")
cipherb64 = run.recvline().strip();
show("cipherb64", cipherb64)
cipher = base64.b64decode(cipherb64)
flag = pow(int.from_bytes(cipher, "little"), key.d, key.n).to_bytes(256, "little")
log.info(flag)
```
