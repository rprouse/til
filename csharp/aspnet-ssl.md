# Renew development SSL Certificates

To force Visual Studio to create a new development SSL certificate for your ASP.NET application, follow these steps:

1. Delete the Existing Certificate
    - Open Windows Certificate Manager: Press `Win` + `R`, type `certmgr.msc`, and press `Enter`.
    - Navigate to `Personal` > `Certificates`.
    - Look for a certificate issued to localhost by ASP.NET Core Development (or similar).
    - Right-click on the expired certificate and select Delete.
2. Remove the Certificate from the Trusted Root Store
    - Navigate to `Trusted Root Certification Authorities` > `Certificates`.
    - Look for the same localhost certificate.
    - Right-click and select Delete.
3. Reset HTTPS Development Certificates
    - Open a command prompt or PowerShell with administrative privileges.
    - Run the following command to reset the ASP.NET Core HTTPS development certificates:

```bash
Copy code
dotnet dev-certs https --clean
dotnet dev-certs https --trust
```

This will remove old certificates and generate a new trusted certificate. Note: The `--trust` option adds the certificate to the trusted root.

## ASP.NET Applications using a Vite.js frontend

Also, navigate to the `%APPDATA%\ASP.NET\Https` on Windows or `$HOME/.aspnet/https` on Linux and delete any `.pem` and `.key` files with your application name.

