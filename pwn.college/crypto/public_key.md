# Public Key Certificates

In this challenge you will work with public key certificates. You will be provided with a self-signed root certificate. You will also be provided with the root private key, and must use that to sign a user certificate.

```python
#!/usr/bin/env python3

import sys
import base64
import json

from Crypto.PublicKey import RSA
from Crypto.Hash.SHA256 import SHA256Hash

from pwn import *

def show(name, value, *, b64=True):
    log.info(f"{name}: {value}")

def show_b64(name, value):
    show(f"{name} (b64)", base64.b64encode(value).decode())

def show_hex(name, value):
    show(name, hex(value))

def recv_hex(run, marker, name):
    run.recvuntil(marker)
    s = run.recvline().strip()
    value = int(s, 16)
    show_hex(name, value)
    return value

def recv_b64(run, name):
    run.recvuntil(b"(b64): ")
    s = run.recvline().strip()
    value = base64.b64decode(s)
    show_b64(name, value)
    return value

def send_b64(run, marker, value):
    run.recvuntil(marker)
    run.sendline(base64.b64encode(value))

# Run the challenge using pwntools
run = process(b"/challenge/run")

user_key = RSA.generate(1024)

# Root key
root_key_d = recv_hex(run, b"d: ", "root key d")

# Root certificate
root_cert_json = recv_b64(run, "root cert")
root_cert = json.loads(root_cert_json)
log.info(root_cert)

# Root certificate signature
root_cert_sig = recv_b64(run, "root cert sig")

# Extract n from the root cert
root_key_n = root_cert['key']['n']

# Create the user cert
user_cert = {
    "name": "user",
    "key": {
        "e": user_key.e,
        "n": user_key.n,
    },
    "signer": "root",
}

# Sign the user cert
user_cert_data = json.dumps(user_cert).encode()
user_cert_hash = SHA256Hash(user_cert_data).digest()
user_cert_sig = pow(
    int.from_bytes(user_cert_hash, "little"),
    root_key_d,
    root_key_n
).to_bytes(256, "little")

send_b64(run, b"user certificate (b64): ", user_cert_data)
send_b64(run, b"user certificate signature (b64): ", user_cert_sig)

# Get the ciphertext that was encrypted with our key and decrypt it
ciphertext = recv_b64(run, "ciphertext")

# Pwn the flag
flag = pow(int.from_bytes(ciphertext, "little"), user_key.d, user_key.n).to_bytes(256, "little")
log.info(flag)
```
