# Backup Bitlocker Key for a Drive

Your Bitlocker keys are stored in the cloud under your Microsoft account, but when re-installing Windows I like to make a backup of the password. You can do so by running the following from an elevated command prompt.

```ps
manage-bde -protectors -get D:
```