# Upgrade .NET Test Project from VSTest to MTP

Open the `CSPROJ` file to the test project and add the following,

```xml
<OutputType>Exe</OutputType>Add commentMore actions
<EnableNUnitRunner>true</EnableNUnitRunner>
<TestingPlatformDotnetTestSupport>true</TestingPlatformDotnetTestSupport>
<TestingPlatformCaptureOutput>false</TestingPlatformCaptureOutput>
```

Update to the latest version of the `NUnit3TestAdapter` and remove the `Microsoft.NET.Test.Sdk` package.

```xml
<!-- Remove -->
<PackageReference Include="NUnit3TestAdapter" Version="4.6.0">Add commentMore actions
      <PrivateAssets>all</PrivateAssets>
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
</PackageReference>
<PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.11.1" />

<!-- Add -->
<PackageReference Include="NUnit3TestAdapter" Version="5.0.0" />
```

You will need to close and reopen the solution before the tests will run.
## Example command with VSTest

```sh
dotnet test --collect "Code Coverage;Format=cobertura" --logger "trx;LogFileName=myfile.trx"
```

## Example command with MTP

```sh
dotnet test -- --report-trx --report-trx-filename myfile.trx --coverage
```
