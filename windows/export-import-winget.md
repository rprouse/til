# Export then Import WinGet Packages

To create a list of packages installed on a Windows machine, you can export,

```ps
winget export -o apps.json
```

You can then edit the JSON to remove unwanted packages and then install on another machine with `winget import`.
