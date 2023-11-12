# ZDE16

Configure with `zdenst16 zde16`, select `t` to configure the terminal, then `l` to list the terminals. Press return until your terminal is shown, then press `y` next to it. Try `ANSI standard`. Now press `ESC` then `s` to save the changes. If you are unsure which terminal to select, try each in turn, then start ZDE to see if it works, pressing `ESC q` to quit.

To read the ZDE documentation, `zde16 zde10.doc`

The editor is started with the command `zde16` and can be run with a filename as an argument. If a filename is supplied, the editor will try to open it, if it doesn't exist then it will start a new file with the name supplied. ZDE uses the Wordstar key combinations which are explained in the ZDE documentation. On some machines the main command key `CTRL+k` is used as a cursor key, in which case `ESC` can be used instead. The most important commands are listed below:

| Command          | Purpose                       |
| ---------------- | ----------------------------- |
| ESC h            | Bring up the command key help |
| CTRL+k q / ESC q | Quit editor without saving    |
| CTRL+k x / ESC x | Exit and Save                |
| CTRL+k l / ESC l | Load a new file               |
| CTRL+k s / ESC s | Save the current file         |
| CTRL+r           | Page up                       |
| CTRL+c           | Page down                     |
| CTRL+e / cursor  | Line up                       |
| CTRL+x / cursor  | Line down                     |
| CTRL+s / cursor  | Cursor left                   |
| CTRL+d / cursor  | Cursor right                  |
