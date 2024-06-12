# AES Decryption

Decrypt a secret encrypted with Advanced Encryption Standard (AES). The Electronic Codebook (ECB) block cipher mode of operation is used.

```python
#!/usr/bin/env python3

import base64
import sys

from Crypto.Cipher import AES

def unpad(s):
    return s[:-s[-1]]

if len(sys.argv) != 3:
    print("Usage: decrypt_aes base64_key base64_secret")
    sys.exit(1)

key = base64.b64decode(sys.argv[1])
secret = base64.b64decode(sys.argv[2])

cipher = AES.new(key=key, mode=AES.MODE_ECB)
message = cipher.decrypt(secret)

# Remove padding
unpadded_message = unpad(message)

# Convert bytes to string
print(unpadded_message.decode('utf-8'))
```
