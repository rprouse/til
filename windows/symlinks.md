# B

You need elevation **or** Developer Mode enabled (Settings → System → For developers), which lets non-admin users create symlinks.

## cmd

```cmd
:: File symlink
mklink C:\path\to\link.txt C:\path\to\target.txt

:: Directory symlink
mklink /D C:\path\to\linkdir C:\path\to\targetdir

:: Directory junction (no special privilege needed, local volumes only)
mklink /J C:\path\to\linkdir C:\path\to\targetdir

:: Hard link (files only, same volume)
mklink /H C:\path\to\link.txt C:\path\to\target.txt
```

The link comes first and the target second, which is the opposite of `ln -s`. `mklink` is a cmd built-in, so from PowerShell you'd call `cmd /c mklink ...`.
## PowerShell

```powershell
New-Item -ItemType SymbolicLink -Path C:\path\to\link -Target C:\path\to\target
New-Item -ItemType Junction     -Path C:\path\to\link -Target C:\path\to\targetdir
New-Item -ItemType HardLink     -Path C:\path\to\link -Target C:\path\to\target
```

PowerShell detects file vs. directory automatically, so it doesn't need a `/D` equivalent.
## Gotchas

- Relative targets are resolved relative to the link's location, not your current directory. 
- Git on Windows checks out symlinks as plain text files unless you have `core.symlinks=true` and symlink permission, which is a common surprise in cross-platform repos. 
- Junctions are often the easier choice for local directories because they work without Developer Mode or admin rights.

To inspect existing links, use `dir /AL` in cmd, or `Get-Item link | Select LinkType, Target` in PowerShell.

## Junctions

A junction is an NTFS **reparse point** attached to an empty directory. The reparse point has the tag `IO_REPARSE_TAG_MOUNT_POINT` and stores an absolute target path, internally in NT form such as `\??\C:\real\target\`. When the I/O manager opens a path that passes through the junction, NTFS returns `STATUS_REPARSE`, and the object manager substitutes the stored target and retries the open. Applications see an ordinary directory and need no special handling.

Volume mount points use the same tag, with a volume GUID path as the target instead of a directory. Junctions predate symlinks, having shipped with Windows 2000, while symlinks arrived in Vista.
## How junctions differ from directory symlinks

| |Junction|Directory symlink|
| --- | --- | --- |
|Targets|Directories only|Files or directories|
|Target path|Always absolute, stored as such|Can be relative|
|Target location|Local volumes only|Local, or UNC/remote (if evaluation policy allows)|
|Privilege needed|None|Admin or Developer Mode|
|Resolution over SMB|On the server|On the client|

The SMB row matters in practice. If a share contains a junction to `D:\data`, a remote client gets the server's `D:\data`, because the server resolves the junction. A symlink to `D:\data` would instead be resolved on the client, against the client's own D: drive, which is usually not what you want.

Because the target is stored as an absolute path, a junction breaks if you move the target or remap the drive letter. Relative symlinks survive being moved together with their target.

## Creating one

```cmd
mklink /J C:\link C:\real\target
```

```powershell
New-Item -ItemType Junction -Path C:\link -Target C:\real\target
```

The link path must not already exist; the command creates the empty directory and attaches the reparse point to it. The target doesn't have to exist at creation time either, so a typo produces a dangling junction rather than an error.

## Inspecting and removing

```cmd
dir /AL                          :: lists <JUNCTION> entries and targets
fsutil reparsepoint query C:\link
```

```powershell
Get-Item C:\link | Select-Object LinkType, Target
```

Remove a junction with `rmdir C:\link` in cmd or `(Get-Item C:\link).Delete()` in PowerShell. Both delete the junction itself and leave the target untouched. Avoid `Remove-Item -Recurse` on a junction in Windows PowerShell 5.1, which has historically been known to follow the link and delete the target's contents. PowerShell 7 handles this correctly, but recursive deletes near reparse points warrant care in either version.

## Where you'll see them

Windows itself creates compatibility junctions such as `C:\Documents and Settings` → `C:\Users`. These deny listing to everyone, which is why you get "Access denied" if you open them directly. They're also commonly used to relocate large directories (game libraries, package caches, `node_modules` stores) to another drive without reconfiguring the application.