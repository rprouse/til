# Calculate Git commits by Author on all branches

This code will loop through every branch in a local Git repository and count the number of commits by each author over the past year. It also counts the number of commits to the default branch.

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
foreach (var developer in commits.Keys)
{
    Console.WriteLine($"{developer}, {commits[developer]}, {defaultCommits[developer]}");
}
```
