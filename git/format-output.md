# Format the oneline output

```sh
git log --all --pretty=format:"%h - %an, %ad : %s" --date=iso
```

- `--all`: This tells git to include commits from all branches.
- `--pretty=format:"%h - %an, %ad : %s"`: This option customizes the format of the output:
  - `%h`: Abbreviated commit hash.
  - `%an`: Author name or `%ae` for email
  - `%ad`: Author date (format respects the `--date` option).
  - `%s`: Subject (commit message).
