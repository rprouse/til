# Unit test non-public methods and classes

You often want to unit test non-public methods and classes in .NET, but you don't want to make them public. The most common solution is to make the methods and classes internal and access them from your unit test project using the [InternalsVisibleTo](https://learn.microsoft.com/en-us/dotnet/api/system.runtime.compilerservices.internalsvisibletoattribute?view=net-9.0&redirectedfrom=MSDN) attribute.

## Unsigned Assemblies

If your assemblies are unsigned, edit AssemblyInfo.cs in the project you are unit testing and add the following attribute,

```csharp
[assembly: InternalsVisibleTo("MyAssembly.Tests")]
```

Remember to add the attribute to your main project and use the name of your test project. Once you do this, you can access internal classes and methods from your test project.

## Signed Assemblies

If your assemblies are signed, you must sign your test assembly and include the full public key in the InternalsVisibleTo attribute.

To do this, use the [Strong Name Tool (sn.exe)](https://learn.microsoft.com/en-us/dotnet/framework/tools/sn-exe-strong-name-tool?redirectedfrom=MSDN) to extract the public key from your test assembly.

1. Open a Visual Studio command prompt
2. CD to the bin directory where your test assembly was built
3. Run the command sn -Tp MyAssembly.Tests

Running this command will produce the following output,

```txt
Microsoft (R) .NET Framework Strong Name Utility  Version 4.0.30319.0
Copyright (c) Microsoft Corporation.  All rights reserved.

Public key (hash algorithm: sha1):
0024000004800000940000000602000000240000525341310004000001000100750098646d1c04
c2a041faaf801521a769535de9a04cd3b4dedccbf73d1a6456bf4fe58814510e84983c72d0460b
8ba85c52a9cacdc4a0786af54e90cb7a81eb2049ecfe6b2c5e20a18fe4b9bff009ada232e980d2
20b3c9586c9c5ee29c29aee8853db7bb90cf5a4c704f5244e1a1085c43060085350329021ec902
47e70eb2

Public key token is a5778f560690a058
```

Copy the full public key and add it to the InternalsVisibleTo attribute in **AssemblyInfo.cs**

```csharp
[assembly: InternalsVisibleTo("MyAssembly.Tests, PublicKey=" +
  "0024000004800000940000000602000000240000525341310004000001000100750098646d1c04" +
  "c2a041faaf801521a769535de9a04cd3b4dedccbf73d1a6456bf4fe58814510e84983c72d0460b" +
  "8ba85c52a9cacdc4a0786af54e90cb7a81eb2049ecfe6b2c5e20a18fe4b9bff009ada232e980d2" +
  "20b3c9586c9c5ee29c29aee8853db7bb90cf5a4c704f5244e1a1085c43060085350329021ec902" +
  "47e70eb2")]
```

## Adding to the CSPROJ file

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <InternalsVisibleTo Include="MyAssembly.Tests" />
  </ItemGroup>
</Project>
```
