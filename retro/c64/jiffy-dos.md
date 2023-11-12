# JiffyDOS

## Function Key Definitions

- f1 Display the directory
- f3 Load a BASIC program
- f5 Load and run a BASIC program
- f7 Load an ML program
- f2 List a BASIC program from disk
- f4 List an ASCII (text) file from disk
- f6 Save a BASIC program
- f8 Scratch a file

The JiffyDOS function key definitions have been designed to work along with the filenames in the directory listing. Once the directory has been listed, the cursor can be moved to the line of the desired filename, the appropriate function key can be pressed, and then RETURN can be pressed when it is OK to proceed with the command.

Using the JiffyDOS function keys with the directory listing eliminates the possibility of filename misspellings. And, there is no need to enter a colon (:) after the filename or erase the filetype characters manually in order to avoid a syntax error. After the function key has been pressed, the filename can be altered if desired.

## Directory and Load Commands

- `@${:filename}` - List the directory with optional filename or glob
- `SHIFT+RUN/STOP` - Load and run the first program on disk. In C64 mode the Commodore key may be used instead of SHIFT.
- `/filename` - Load a BASIC program
- `↑filename` - Load and run a BASIC program
- `←filename` - Save a BASIC program
- `%filename` - Load a machine language program
- `£filename` - Load and run a machine language program
- `'filename` - Verifies a BASIC file in memory against a file on disk
- `@R:newname=oldname` - Rename a file on disk
- `@S:file1{,file2}...` - Scratch/Delete a file on disk
- `@L:filename` - Locks/Unlocks a file on disk

## File Listings

Holding down `CTRL` will pause listing. Hit `CTRL+S` to stop the listing. Press any key except `CTRL`, `RUN/STOP`, `SHIFT` or the Commodore Key to resume listing. Single step with `CTRL+W`. Break out of listing by holding down `RUN/STOP`.

- `@D:filename` - List a BASIC file from disk.
- `@T:filename` - List an ASCII file from disk.

## Misc Commands

- `@O` - Recover a BASIC program after mistakenly typing `NEW`.
- `@Q` - Disable JiffyDOS commands
- `SYS 58451` - Re-enable JiffyDOS
