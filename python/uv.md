# uv

[uv](https://github.com/astral-sh/uv) is a fast [Python](./python.md) package and project manager written in Rust. It is a single tool to replace `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more.

## Installation

Standalone installers:

```shell
# On macOS and Linux.
curl -LsSf https://astral.sh/uv/install.sh | sh
```

```powershell
# On Windows.
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Or, from [PyPI](https://pypi.org/project/uv/) with [pipx](./pipx.md):

```shell
pipx install uv
```

If installed via the standalone installer, uv can update itself to the latest version:

```shell
uv self update
```

## Projects

See the [project documentation](https://docs.astral.sh/uv/guides/projects/)

```sh
$ uv init example
Initialized project `example` at `/home/user/example`

$ cd example

$ uv add ruff
Creating virtual environment at: .venv
Resolved 2 packages in 170ms
   Built example @ file:///home/user/example
Prepared 2 packages in 627ms
Installed 2 packages in 1ms
 + example==0.1.0 (from file:///home/user/example)
 + ruff==0.5.0

$ uv run ruff check
All checks passed!

$ uv lock
Resolved 2 packages in 0.33ms

$ uv sync
Resolved 2 packages in 0.70ms
Audited 1 package in 0.02ms
```

## Scripts

See the [scripts documentation](https://docs.astral.sh/uv/guides/scripts/)

```sh
# Add the requests module to the script
uv add --script example.py requests

# Run the script in an isolated environment
uv run example.py
```
