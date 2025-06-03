# dotnet run app.cs
.NET 10 introduces the ability to run C# files directly without a `csproj` file using `dotnet run app.cs`.

## NuGet packages
Add NuGet package references using the `#:package` directive.
```csharp
#:package Humanizer@2.14.1

using Humanizer;

var dotNet9Released = DateTimeOffset.Parse("2024-12-03");
var since = DateTimeOffset.Now - dotNet9Released;

Console.WriteLine($"It has been {since.Humanize()} since .NET 9 was released.");
```

## Specify an SDK
By default, file-based apps use the `Microsoft.NET.Sdk`. To use a different SDK, use the `#:sdk` directive.
```csharp
#:sdk Microsoft.NET.Sdk.Web
```

## Set MSBuild Properties
Configure additional build properties with `#:property` directives.
```csharp
#:property LangVersion preview
```

## Self-Running Scripts

```csharp
#!/usr/bin/dotnet run
Console.WriteLine("Hello from a C# script!");
```

You can make the file executable and run it directly: 

```bash
chmod +x app.cs
./app.cs
```

As of preview 4, it does not support a path like `#!~/.dotnet/dotnet run`.

## Converting to a project-based app

To convert to a project-based app,

```bash
dotnet project convert app.cs
```

This command creates a new directory named for your file, scaffolds a `.csproj` file, moves your code into a `Program.cs` file, and translates any `#:` directives into MSBuild properties and references.

## Reference
The specification for this feature is in the `dotnet/sdk` repo at [dotnet-run-file.md](https://github.com/dotnet/sdk/blob/main/documentation/general/dotnet-run-file.md).
