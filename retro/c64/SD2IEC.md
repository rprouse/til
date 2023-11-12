# SD2IEC

Most of the commands are enhanced with [JiffyDOS](./jiffy-dos.md).

## Changing Directories

- `OPEN1,8,15,"CD/DIRECTORY/":CLOSE1` - Change to DIRECTORY relative
- `OPEN1,8,15,"CD//":CLOSE1` - Change to root directory
- `OPEN1,8,15,"CD//DIRECTORY/":CLOSE1` - Change to DIRECTORY absolute
- `OPEN1,8,15,"CD:←":CLOSE1` - Change to parent directory

## Switching D64 Image

- `OPEN1,8,15"CD//DIRECTORY/:FILENAME.D64":CLOSE1` - Change to/mount FILENAME.D64 (Also works with M2I files)
- `OPEN1,8,15,"CD:←":CLOSE1` - Exit D64

## Loading Files

- `LOAD"//DIRECTORY/:FILENAME` - Load FILENAME in DIRECTORY

