# Poetry

[Python](./python.md) packaging and dependency management. [Python Poetry](https://python-poetry.org/).

## Install

Install Poetry with [pipx](./pipx.md).

```sh
pipx install poetry
pipx upgrade poetry
```

## Project Setup

Create our new project, called `my-app`:

```bash
poetry new my-app
```

This will create the `my-app` directory with the following content:

```text
my-app
├── pyproject.toml
├── README.md
├── src
│   └── my-app
│       └── __init__.py
└── tests
    └── __init__.py
```

The `pyproject.toml` file orchestrates your project and its dependencies.

```toml
[project]
name = "my-app"
version = "0.1.0"
description = ""
authors = [
    {name = "Rob Prouse", email = "rob@prouse.org"}
]
readme = "README.md"
requires-python = ">=3.10"
dependencies = [
]

[build-system]
requires = ["poetry-core>=2.0.0,<3.0.0"]
build-backend = "poetry.core.masonry.api"
```

## Initializing a pre-existing project

```sh
cd my-project
poetry init
```

## Adding dependencies

```sh
poetry add pendulum
```

## Activating the environment

### Bash and Zsh

```bash
eval $(poetry env activate)
poetry env info
```

### Powershell

```ps1
Invoke-Expression (poetry env activate)
poetry env info
```

## Operating Modes

By default Poetry operates in **package mode** which is appropriate if you want to package your project and publish it. If not, you can disable **package mode** in the TOML file.

```toml
[tool.poetry]
package-mode = false
```

You can now do `poetry install` to only install the dependencies instead of `poetry install --no-root`.