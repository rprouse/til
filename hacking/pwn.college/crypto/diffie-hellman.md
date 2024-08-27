# Diffie-Hellman key exchange

1. Alice and Bob publicly agree to use a modulus `p` and base `g`, where `p` is prime and `g` is a primitive root modulo `p`
2. Alice chooses a secret integer `a`
3. Alice calculates her public key `A = g^a % p` and sends to Bob
4. Bob chooses a secret integer `b`
5. Bob calculates his public key `B = g^b % p` and sends to Alice
6. Alice computes `s = B^a % p`
7. Bob computes `s = A^b % p`
8. Alice and Bob encrypt/decrypt the message by XORing with `s`

```python
#!/usr/bin/env python3

import sys
import string
import base64

from pwn import *

from Crypto.Random.random import getrandbits
from Crypto.Util.strxor import strxor

def show(name, value, *, b64=True):
    log.info(f"{name}: {value}")

def show_hex(name, value):
    show(name, hex(value))

# Using pwntools to run the challenge process
run = process(b"/challenge/run")

# Receive the agreed upon modulus p from Alice
run.recvuntil(b"p: ")
pstr = run.recvline().strip();
p = int(pstr, 16)
show_hex("p", p)

# Receive the agreed upon base g from Alice
run.recvuntil(b"g: ")
gstr = run.recvline().strip();
g = int(gstr, 16)
show_hex("g", g)

# Receive Alice's public key A
run.recvuntil(b"A: ")
Astr = run.recvline().strip();
A = int(Astr, 16)
show_hex("A", A)

# Bob chooses a secret key b
b = getrandbits(2048)

# Bob calculates his public key B = g^b % p
B = pow(g, b, p)
show_hex("B", b)

# Bob sends his public key B to Alice
run.recvuntil(b"B: ")
run.sendline(hex(B))

# Alice encrypts the data using Bob's public
# key B and her private key a, then sends the
# resulting encrypted text base64 encoded
run.recvuntil(b"secret ciphertext (b64): ")
secretb64 = run.recvline().strip();
secret = base64.b64decode(secretb64)

# Bob computes his s and uses it to decrypt the message
s = pow(A, b, p)
key = s.to_bytes(256, "little")
plaintext = strxor(secret, key[:len(secret)])
log.info(plaintext)
```
