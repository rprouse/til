# Enable Trust on a Dev Drive
After reinstalling Windows, my Dev drive was properly mounted and Bitlocker was working, but the drive showed up with a warning that it was not trusted. To remove,

```ps
fsutil devdrv query D:
fsutil devdrv trust D:
```

