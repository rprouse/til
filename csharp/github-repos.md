# List repositories in a GitHub Organization

Use the GitHub API to get a list of private repositories from an organization.
This requires that you set your API key as an environment variable to keep it
secure.

This code increases the number of repos fetched to 100 from the default 30. If
there are more than 100 repositories, you will need to paginate with `&page=N`.

```csharp
using System;
using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Text.Json;

string token = Environment.GetEnvironmentVariable("GITHUB_TOKEN");
string organization = "YOUR_ORG_NAME"; // Replace with the organization name
string url = $"https://api.github.com/orgs/{organization}/repos?type=private&sort=full_name&per_page=100";

using HttpClient client = new();

client.DefaultRequestHeaders.Add("User-Agent", "C# App");
client.DefaultRequestHeaders.Add("Accept", "application/vnd.github+json");
client.DefaultRequestHeaders.Add("X-GitHub-Api-Version", "2022-11-28");
client.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}");

HttpResponseMessage response = await client.GetAsync(url);
if (response.IsSuccessStatusCode)
{
  string content = await response.Content.ReadAsStringAsync();
  var repositories = JsonSerializer.Deserialize<List<Repository>>(content);

  foreach (var repo in repositories)
  {
      Console.WriteLine($"{repo.Name} - {repo.HtmlUrl}");
  }
}
else
{
  Console.WriteLine($"Error: {response.StatusCode}");
}

public class Repository
{
    [JsonPropertyName("name")]
    public string Name { get; set; }

    [JsonPropertyName("description")]
    public string Description { get; set; }

    [JsonPropertyName("html_url")]
    public string HtmlUrl { get; set; }
}

```
