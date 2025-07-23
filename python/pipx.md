# pipx

Installs and Runs [Python](./python.md) Applications in Isolated Environments.
## Linux Install

```sh
# On Ubuntu 23.04 or higher
sudo apt update
sudo apt install pipx
pipx ensurepath

# Using pip
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```

## Windows Install

```sh
python -m pip install --user pipx
python -m pipx ensurepath
```

It is possible (even most likely) the above finishes with a WARNING looking similar to this:

```txt
WARNING: The script pipx.exe is installed in `<USER folder>\AppData\Roaming\Python\Python3x\Scripts` which is not on PATH
```

If so, go to the mentioned folder, allowing you to run the pipx executable directly. Enter the following line (even if you did not get the warning):

```sh
.\pipx.exe ensurepath
```

This will add both the above mentioned path and the `%USERPROFILE%\.local\bin` folder to your search path. Restart your terminal session and verify `pipx` does run.

## Installing Programs

```sh
pipx install poetry
pipx list
```

