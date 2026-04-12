# Git Submodules

## Add git submodule

```sh
git submodule add https://github.com/rprouse/library.git
```

## Cloning repositories with submodules

```sh
git clone https://github.com/rprouse/repo.git
git submodule init
git submodule update
```

## Remove a submodule from a repository

```sh
git submodule deinit -f path/to/submodule
git rm -f path/to/submodule
rm -rf .git/modules/path/to/submodule
git commit -m "Remove submodule path/to/submodule"
```
