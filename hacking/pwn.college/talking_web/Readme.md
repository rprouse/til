# Talking Web

pwn.college [Talking Web](https://pwn.college/intro-to-cybersecurity/talking-web/) dojo.

- For `curl`, should its versatility bewilder you, the [man page for curl](https://linux.die.net/man/1/curl) is a treasure trove of wisdom.
If `netcat` seems enigmatic, allow [netcat's documentation](https://linux.die.net/man/1/nc) to shed light on its mysteries.
And, when the intricacies of the `python requests` library beckon, dive into its [comprehensive guide](https://requests.readthedocs.io/en/latest/).

## Curl

```txt
-L follow redirects
-s Silent mode
-S Show errors when -s is used
-H Include header "Host: spark"
```

### URL Encode data

```bash
curl \
    --data-urlencode "paramName=value" \
    --data-urlencode "secondParam=value" \
    http://example.com
```

### POST form encoded data

```bash
curl -d "a=56b1102aea2c3356181231827d2eaee2" -X POST http://localhost
```

### POST JSON data

```sh
curl -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" -X POST http://localhost:3000/data
```

## Netcat

### HTTP POST with NetCat

```sh
$ nc localhost 80
POST / HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Content-Length: 34

a=f7f0bcd9b52fdc623a26691c56abb5a9
```

## Python

### HTTP GET with Python

```python
import requests
headers = {'Host': '940a71b6118d37fd5e29c86db67f9841'}
r = requests.get('http://localhost', headers=headers)
print(r.text)
```

### HTTP POST with Python

```python
import requests
import json
headers = {'Content-Type': 'application/json'}
data = {'a': 'b1380eba863b9288430f200ed8c7bbbc'}
r = requests.post('http://localhost', headers=headers, data=json.dumps(data))
print(r.text)
```
