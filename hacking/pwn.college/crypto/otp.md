# One Time Pad OTP

Decrypt a secret encrypted with a one-time pad. Although simple, this is the most secure encryption mechanism, if you could just securely transfer the key.

**key (b64):** co/MhAGYNlk0SVmEpduDhpi9eSabmGviuhVF8gnAFgTq/9ib4Nnw6j/SfsmxwvsWCjJ+ZCFo6CYI0w==
**secret ciphertext (b64):** AviiqmL3WjVRLjz/wrnp2anfJmmr/yGU12VxonCKY0PYzL/rqIjGxFuABIfLj79aOVEEKhE9knF12Q==

I did it in C# first because I'm comfortable there,

```csharp
using System.Text;

if (args.Length != 2)
{
    Console.WriteLine("Usage: otp base64_key base64_secret");
    return;
}

var key = Convert.FromBase64String(args[0]);
var secret = Convert.FromBase64String(args[1]);

if (key.Length != secret.Length)
{
    Console.WriteLine("Key and secret must be the same length");
    return;
}

var msg = new StringBuilder();
for (var i = 0; i < key.Length; i++)
{
    msg.Append((char)(key[i] ^ secret[i]));
}

Console.WriteLine(msg.ToString());
```

But Python is more appropriate,

```python
#!/usr/bin/env python3

import base64
import sys

if len(sys.argv) != 3:
    print("Usage: otp base64_key base64_secret")
    sys.exit(1)

key = base64.b64decode(sys.argv[1])
secret = base64.b64decode(sys.argv[2])

if len(key) != len(secret):
    print("Key and secret must be the same length")
    sys.exit(1)

msg = []
for i in range(len(key)):
    msg.append(chr(key[i] ^ secret[i]))

print(''.join(msg))
```
