# List repositories in an Azure DevOps Project

To use the Azure DevOps API, you'll need a Personal Access Token (PAT). This
token is used to authenticate your requests. I store it in an environment variable.

```csharp
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Text.Json;

// Replace these with your actual values
var personalAccessToken = Environment.GetEnvironmentVariable("ADO_TOKEN");
var organization = "YOUR_ORGANIZATION";
var project = "YOUR_PROJECT";

// Construct the URL
var url = $"https://dev.azure.com/{organization}/{project}/_apis/git/repositories?api-version=6.0";

HttpClient client = new();
client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic",
    Convert.ToBase64String(System.Text.Encoding.ASCII.GetBytes($":{personalAccessToken}")));

try
{
    var response = await client.GetAsync(url);
    response.EnsureSuccessStatusCode();
    var responseBody = await response.Content.ReadAsStringAsync();

    // Parse and display the repositories
    using var doc = JsonDocument.Parse(responseBody);
    foreach (var repo in doc.RootElement.GetProperty("value").EnumerateArray())
    {
        Console.WriteLine(repo.GetProperty("remoteUrl").GetString());
    }
}
catch (HttpRequestException e)
{
    Console.WriteLine("\nException Caught!");
    Console.WriteLine("Message :{0}", e.Message);
}
```
