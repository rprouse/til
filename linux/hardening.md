# Security Hardening a Debian based Linux box

## Update the system

```sh
sudo apt update -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
```

Or `sudo apt dist-upgrade`.

## Fail2Ban

Install and configure `fail2ban`

```sh
sudo apt install fail2ban -y  # Install
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.bak # Backup the config
sudo vi /etc/fail2ban/jail.conf
```

```ini
...snip...

# [sshd]
enabled = true
bantime = 4w
maxretry = 3
```

## Update SSH Configuration

Make a backup of then edit `/etc/ssh/sshd_config`

```ini
LogLevel VERBOSE	# Gives the verbosity level that is used when logging messages from SSH daemon.
PermitRootLogin no	# Specifies whether root can log in using SSH.
MaxAuthTries 3	# Specifies the maximum number of authentication attempts permitted per connection.
MaxSessions 5	# Specifies the maximum number of open shell, login, or subsystem (e.g., SFTP) sessions allowed per network connection.
HostbasedAuthentication no	# Specifies whether rhosts or /etc/hosts.equiv authentication together with successful public key client host authentication is allowed (host-based authentication).
PermitEmptyPasswords no	# When password authentication is allowed, it specifies whether the server allows login to accounts with empty password strings.
ChallengeResponseAuthentication yes	# Specifies whether challenge-response authentication is allowed.
UsePAM yes	# Specifies if PAM modules should be used for authentification.
X11Forwarding no	# Specifies whether X11 forwarding is permitted.
PrintMotd no	# Specifies whether SSH daemon should print /etc/motd when a user logs in interactively.
ClientAliveInterval 600	# Sets a timeout interval in seconds, after which if no data has been received from the client, the SSH daemon will send a message through the encrypted channel to request a response from the client.
ClientAliveCountMax 0	# Sets the number of client alive messages which may be sent without SSH daemon receiving any messages back from the client.
AllowUsers <username>	# This keyword can be followed by a list of user name patterns, separated by spaces. If specified, login is allowed only for user names that match one of the patterns.
Protocol 2	# Specifies the usage of the newer protocol which is more secure.
AuthenticationMethods publickey,keyboard-interactive	# Specifies the authentication methods that must be successfully completed for a user to be granted access.
PasswordAuthentication no	# Specifies whether password authentication is allowed.
```

## Enable 2FA for SSH

We can use the [Google-Authenticator PAM Module](https://github.com/google/google-authenticator-libpam) to enable 2FA.

```sh
$ sudo apt install libpam-google-authenticator -y
[cry0l1t3@VPS ~]$ google-authenticator

Do you want authentication tokens to be time-based (y/n) y

Warning: pasting the following URL into your browser exposes the OTP secret to Google:
  https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/cry0l1t3@parrot%3Fsecret%...SNIP...%26issuer%3Dparrot

   [ ---- QR Code ---- ]

Your new secret key is: ***************
Enter code from app (-1 to skip): 123456

Code confirmed
Your emergency scratch codes are:
  21323478
  43822347
  60232018
  73234726
  45456791

Do you want me to update your "/home/cry0l1t3/.google_authenticator" file? (y/n) y

Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, a new token is generated every 30 seconds by the mobile app.
In order to compensate for possible time-skew between the client and the server,
we allow an extra token before and after the current time. This allows for a
time skew of up to 30 seconds between authentication server and client. If you
experience problems with poor time synchronization, you can increase the window
from its default size of 3 permitted codes (one previous code, the current
code, the next code) to 17 permitted codes (the 8 previous codes, the current
code, and the 8 next codes). This will permit for a time skew of up to 4 minutes
between client and server.
Do you want to do so? (y/n) n

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting? (y/n) y
```

Next we need to configure the PAM module for the SSH daemon. Create a backup then edit `/etc/pam.d/sshd`.

```ini
#@include common-auth

...SNIP...

auth required pam_google_authenticator.so
auth required pam_permit.so
```

Next, edit `/etc/ssh/sshd_config` to allow this authentication method,

```ini
...SNIP...

AuthenticationMethods publickey,keyboard-interactive
PasswordAuthentication no
```

Finally, restart the SSH daemon,

```sh
sudo service ssh restart
```
