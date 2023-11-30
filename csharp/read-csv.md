# Read a CSV File

To read a CSV file in C#, use the `CvsHelper` package.

```sh
Install-Package CsvHelper
```

```csharp
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using CsvHelper;
using CsvHelper.Configuration;

CsvConfiguration config = new(CultureInfo.InvariantCulture);
using StreamReader reader = new("path/to/your/file.csv");
using CsvReader csv = new(reader, config);

var records = new List<Person>();
csv.Read();
csv.ReadHeader();
while (csv.Read())
{
    records.Add(new Person
    {
        FirstName = csv.GetField("FirstName"),
        LastName = csv.GetField("LastName"),
        Age = int.Parse(csv.GetField("Age"))
    });
}

// Now `records` is a list of `Person` objects containing the data from your CSV
foreach (var record in records)
{
    Console.WriteLine($"{record.FirstName} {record.LastName}, age {record.Age}");
}

public class Person
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public int Age { get; set; }
}
```
