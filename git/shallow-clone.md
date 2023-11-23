# Git Shallow Clone

When cloning a Git repository to a build machine, you can reduce the size and
increase the download speed significantly by doing a shallow clone. A shallow
clone only gets the most recent commit with the command `--depth=1`. It is
often combined with `--single-branch --branch=<branch>` to only pull a single
branch.

```sh
git clone --depth=1 --single-branch --branch=release git@github.com:rprouse/repo.git
```
