# Unblock Downloaded PDF and Other Files

When you download files from the Internet, you cannot preview them in File Explorer or open them in Word for editing without unblocking them. That is easy enough to do in the file properties, but tedious for many files like PDF receipts.
## Unblock everything in a folder

Open PowerShell, navigate to (or point at) the folder with your PDFs, and run:

```powershell
Get-ChildItem -Path . -Recurse | Unblock-File
```

- `-Path` points at your folder
- `-Recurse` also unblocks files in subfolders, so drop it if you only want the top level.
- This works on any file type, not just PDFs, so if the folder has other stuff in it that's fine — `Unblock-File` on a file that isn't blocked just does nothing.

## Filter to just PDFs if you want to be precise

```powershell
Get-ChildItem -Path . -Filter *.pdf -Recurse | Unblock-File
```
