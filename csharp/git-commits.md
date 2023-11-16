# Count Git merge commits by Author

This code counts the number of merge commits on the default branch. It only works with GitHub repositories.

The code uses `LibGit2Sharp`,

```sh
Install-Package LibGit2Sharp
```

```csharp
using LibGit2Sharp;

const string repoPath = @"D:\src\pathToRepo";
const string defaultBranch = "main";
var oneYearAgo = DateTimeOffset.Now.AddMonths(-12);

// Commits to all branches including default
Dictionary<string, int> commits = new();

// Commits to the default branch
Dictionary<string, int> defaultCommits = new();

using Repository repo = new(repoPath);

foreach (var branch in repo.Branches)
{
    foreach (var commit in branch.Commits.Where(c => c.Author.When >= oneYearAgo))
    {
        string author = commit.Author.Name;
        string branchName = branch.FriendlyName;

        if (!commits.ContainsKey(author))
        {
            commits[author] = 0;
            defaultCommits[author] = 0;
        }

        commits[author]++;
        if (branch.FriendlyName == defaultBranch)
            defaultCommits[author]++;
    }
}

// Print the stats
foreach (var dev in commits.Keys)
{
    Console.WriteLine($"{dev}, {commits[dev]}");
}
```
