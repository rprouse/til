# OWASP Juice Shop

The [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) is a modern SPA insecure web application for security training, demos and CTFs. Juice Shop encompasses vulnerabilities from the entire [OWASP Top Ten](https://owasp.org/www-project-top-ten) along with many other security flaws found in real-world applications.

The Juice Shop has a companion book [Pwning OWASP Juice Shop](https://pwning.owasp-juice.shop/companion-guide/latest/) which is the official guide. It has a complete overview of the vulnerabilities found in the application including hints how to spot and exploit them.

## Running

- Run `docker run -d -p 127.0.0.1:3000:3000 bkimminich/juice-shop` to launch the container with that image.
- Browse to http://localhost:3000.

## Notes

- Admin email is `admin@juice-sh.op` and password is `admin123`
