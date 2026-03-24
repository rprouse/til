# Unblock a Downloaded PowerShell Script

Scripts downloaded from the Internet are blocked by default unless they are digitally signed. For known good scripts like installers, you can unblock the file using PowerShell's `Unblock-File` cmdlet:

```powershell
Unblock-File -Path .\YourScript.ps1
```

This removes the Zone.Identifier alternate data stream that Windows attaches to files downloaded from the internet (the "Mark of the Web"), which is what triggers the execution policy restriction.

You can verify it worked with:

```powershell
Get-Item .\YourScript.ps1 -Stream *
```

If the `Zone.Identifier` stream is gone from the output, you're clear to run it.

Alternatively, you can do it through Explorer: right-click the `.ps1` file → Properties → check **Unblock** at the bottom of the General tab → OK.