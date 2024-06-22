# File Inclusion Vulnerability

- Learned from Hack The Box [Starting Point](https://app.hackthebox.com/starting-point) **Responder**.
- Wordlist of [common vulnerable files](https://github.com/carlospolop/Auto_Wordlists/blob/main/wordlists/file_inclusion_windows.txt).

## Overview

Dynamic websites often include HTML pages using information from HTTP requests, which may involve parameters from GET and POST requests, cookies, and other variables. When this inclusion is improperly handled, it can lead to vulnerabilities such as Local File Inclusion (LFI) and Remote File Inclusion (RFI).

## Local File Inclusion (LFI)

- **Description:** LFI occurs when an attacker can make a website include files that are not intended to be accessible. This typically happens when the application treats file path inputs as trusted without proper sanitization.
- **Exploitation:** Attackers use directory traversal sequences (`../`) to navigate to sensitive files within the server's file system. For example, an application might include a file based on user input like `page=../../../../../../../../windows/system32/drivers/etc/hosts`, allowing the attacker to view the `hosts` file.
- **Risk:** In some cases, LFI can lead to code execution if the included file is a script or contains executable code.

## Remote File Inclusion (RFI)

- **Description:** RFI is similar to LFI but involves including remote files from external sources using protocols such as HTTP or FTP.
- **Exploitation:** Attackers can specify a remote URL as the file to be included, which can lead to the execution of malicious code hosted on the remote server.

## Testing for Vulnerability

- **Example:** A penetration tester might attempt to include common files with predictable paths, such as the `hosts` file on Windows (`C:\windows\system32\drivers\etc\hosts`), to check for LFI.
- **Method:** The inclusion vulnerability can be identified by manipulating the `page` parameter in the URL and observing if the application includes unintended files.

## Prevention

- **Sanitization:** Proper sanitization of input parameters is crucial. This includes validating, filtering, and escaping user inputs.
- **Use of Secure Functions:** Developers should use secure methods for including files and avoid using direct user inputs for file paths.

## Example Scenario

- The provided URL `http://unika.htb/index.php?page=../../../../../../../../windows/system32/drivers/etc/hosts` demonstrates a successful LFI exploitation by including and displaying the contents of the `hosts` file.
- The vulnerability was possible due to improper sanitization in the PHP `include()` method used in the backend to process the `page` parameter for serving different language pages.

In conclusion, both LFI and RFI are severe vulnerabilities resulting from improper handling of file inclusion mechanisms. Proper input validation and secure coding practices are essential to prevent such exploits.
