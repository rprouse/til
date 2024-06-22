# Logging pen-testing attempts

Logging is essential for both documentation, learning and our protection. If third parties attack the company during a penetration test, we can prove that the damage did not result from our activities. For this, we can use the tools `script` on Linux and `Start-Transcript` on Windows.

## Linux

```sh
script -a 2024-06-22-1652-session.log -T 2024-06-22-1652-timing.log
```

Then type `exit` to stop recording.

```sh
scriptreplay -B 2024-06-22-1652-session.log -t 2024-06-22-1652-timing.log
```

To replay the log.

## Windows

```powershell
Start-Transcript -Path "2024-06-22-1652-exploitation.log"
```

Then type `Stop-Transcript` to stop recording.
