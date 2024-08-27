# TLS Handshake

Perform a simplified TLS handshake as the server, completing a Diffie-Hellman key exchange and establishing an encrypted channel to provide a user certificate and prove private key ownership.

In this challenge you will perform a simplified Transport Layer Security (TLS) handshake, acting as the server.

1. You will be provided with Diffie-Hellman parameters, a self-signed root certificate, and the root private key.
2. The client will request to establish a secure channel with a particular name, and initiate a Diffie-Hellman key exchange.
3. The server must complete the key exchange, and derive an AES-128 key from the exchanged secret.
4. Then, using the encrypted channel, the server must supply the requested user certificate, signed by root.
5. Finally, using the encrypted channel, the server must sign the handshake to prove ownership of the private user key.

```python
#!/usr/bin/env python3

import sys
import base64
import json

from Crypto.Cipher import AES
from Crypto.PublicKey import RSA
from Crypto.Hash.SHA256 import SHA256Hash
from Crypto.Random.random import getrandbits
from Crypto.Util.strxor import strxor
from Crypto.Util.Padding import pad, unpad

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

def send_hex(run, marker, value):
    run.recvuntil(marker)
    run.sendline(hex(value))

# Run the challenge using pwntools
run = process(b"/challenge/run")

user_key = RSA.generate(1024)

# 1. You will be provided with Diffie-Hellman parameters, a self-signed root
# certificate, and the root private key.

# Diffie-Hellman parameters
# p: 2048-bit MODP Group from RFC3526
p = recv_hex(run, b"p: ", "p")
g = recv_hex(run, b"g: ", "g")

# Root private key
root_key_d = recv_hex(run, b"d: ", "root key d")

# Root certificate
root_cert_json = recv_b64(run, "root cert")
root_cert = json.loads(root_cert_json)
log.info(root_cert)

# Root certificate signature
root_cert_sig = recv_b64(run, "root cert sig")

# Extract n from the root cert
root_key_n = root_cert['key']['n']

# 2. The client will request to establish a secure channel with a particular
# name, and initiate a Diffie-Hellman key exchange.
# Get the name
run.recvuntil(b"name: ");
name = run.recvlineS().strip()

# Get A
A = recv_hex(run, b"A: ", "A")

# Create and send B
b = getrandbits(2048)

# Calculate public key B = g^b % p
B = pow(g, b, p)
show_hex("B", b)
send_hex(run, b"B: ", B)

# 3. The server must complete the key exchange, and derive an AES-128 key from
# the exchanged secret.
s = pow(A, b, p)
key = SHA256Hash(s.to_bytes(256, "little")).digest()[:16]
cipher_encrypt = AES.new(key=key, mode=AES.MODE_CBC, iv=b"\0"*16)
cipher_decrypt = AES.new(key=key, mode=AES.MODE_CBC, iv=b"\0"*16)

# 4. Then, using the encrypted channel, the server must supply the requested
# user certificate, signed by root.
# Create the user cert
user_cert = {
    "name": name,
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

# Encrypt the user cert and the signature
user_cert_secret = cipher_encrypt.encrypt(pad(user_cert_data, cipher_encrypt.block_size))
user_cert_sig_secret = cipher_encrypt.encrypt(pad(user_cert_sig, cipher_encrypt.block_size))

log.info(b"sending user certificate")
send_b64(run, b"user certificate (b64): ", user_cert_secret)
log.info(b"sending user certificate signature")
send_b64(run, b"user certificate signature (b64): ", user_cert_sig_secret)

# 5. Finally, using the encrypted channel, the server must sign the handshake
# to prove ownership of the private user key.
user_signature_data = (
    name.encode().ljust(256, b"\0") +
    A.to_bytes(256, "little") +
    B.to_bytes(256, "little")
)
# Sign it
user_signature_hash = SHA256Hash(user_signature_data).digest()
user_signature = pow(
    int.from_bytes(user_signature_hash, "little"),
    user_key.d,
    user_key.n
).to_bytes(256, "little")

user_signature_sec = cipher_encrypt.encrypt(pad(user_signature, cipher_encrypt.block_size))

log.info(b"sending user signature")
send_b64(run, b"user signature (b64): ", user_signature_sec)

# Get the ciphertext that was encrypted with our key and decrypt it
ciphertext = recv_b64(run, "ciphertext")

# Pwn the flag
#flag = pow(int.from_bytes(ciphertext, "little"), user_key.d, user_key.n).to_bytes(256, "little")
flag = unpad(cipher_decrypt.decrypt(ciphertext), cipher_decrypt.block_size)
log.info(flag)
```
