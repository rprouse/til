# Code Coverage with Coverlet in .NET

⚠️ this does not work with the new [MTP](./mtp.md) test project format.
## Install Coverlet

Add the [coverlet](https://github.com/coverlet-coverage/coverlet) NuGet package to the test project.

```sh
dotnet add package coverlet.collector
```

## Run Tests with Coverage

Use this command to run tests and collect coverage:

```sh
dotnet test --collect:"XPlat Code Coverage"
```

This will generate a `coverage.cobertura.xml` file in the `TestResults` folder.

##  View the Coverage Report

You can use ReportGenerator to turn the .xml into a readable HTML report:

```sh
dotnet tool install -g dotnet-reportgenerator-globaltool

reportgenerator -reports:**/coverage.cobertura.xml -targetdir:CoverageReport
```

Open the `CoverageReport/index.html` to view your report.

### View in Visual Studio

If you're using Visual Studio on Windows, you can use the [Fine Code Coverage](https://marketplace.visualstudio.com/items?itemName=FortuneNgwenya.FineCodeCoverage) extension. Visualization is updated when you run unit tests inside Visual Studio.