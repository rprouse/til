# VS Code Jupyter Notebook Keybindings

Press `Esc` to enter **command mode**. Press `Enter` to enter **edit mode**.

Almost everything below only works in command mode. If a letter key types a letter instead of doing something, you're still in edit mode.

> [!info] Platform Bindings are shown for Windows and Linux. On macOS, substitute `Cmd` for `Ctrl` in the chorded shortcuts; the bare-letter command-mode keys are identical.

## Cell Execution

| VS Code       | Jupyter       | Action                                        |
| ------------- | ------------- | --------------------------------------------- |
| `Ctrl+Enter`  | `Ctrl+Enter`  | Run cell, stay on it                          |
| `Shift+Enter` | `Shift+Enter` | Run cell, select cell below                   |
| `Alt+Enter`   | `Alt+Enter`   | Run cell, insert new cell below               |
| —             | —             | Run all cells (`notebook.execute` / Run menu) |
| —             | —             | Run all above / all below (menu or palette)   |
| —             | `I` `I`       | Interrupt kernel                              |
| —             | `0` `0`       | Restart kernel                                |

In VS Code, `Alt+Enter` inserts a **code** cell. In Jupyter, it inserts a cell of the same type as the one you just ran. Neither gives you a choice. See the custom bindings below.

## Command Mode

|VS Code|Jupyter|Action|
|---|---|---|
|`Esc`|`Esc`|Leave edit mode, enter command mode|
|`Enter`|`Enter`|Enter edit mode on selected cell|
|`Up`|`Up` or `K`|Select cell above|
|`Down`|`Down` or `J`|Select cell below|
|`Shift+Up`|`Shift+Up` or `Shift+K`|Extend selection up|
|`Shift+Down`|`Shift+Down` or `Shift+J`|Extend selection down|
|`Ctrl+Shift+P`|`Ctrl+Shift+P` or `P`|Command palette|
|`Ctrl+F`|`F`|Find and replace|
|`Ctrl+K Ctrl+S`|`H`|Show keyboard shortcuts|
|`L`|`L`|Toggle line numbers|
|`O`|`O`|Toggle cell output|
|`Ctrl+S`|`Ctrl+S` or `S`|Save notebook|

## Cell Manipulation

|VS Code|Jupyter|Action|
|---|---|---|
|`A`|`A`|Insert cell above|
|`B`|`B`|Insert cell below|
|`M`|`M`|Change cell to markdown|
|`Y`|`Y`|Change cell to code|
|—|`R`|Change cell to raw|
|`X`|`X`|Cut selected cells|
|`C`|`C`|Copy selected cells|
|`V`|`V`|Paste cells below|
|—|`Shift+V`|Paste cells above|
|`D` `D`|`D` `D`|Delete selected cells|
|`Ctrl+Z`|`Z`|Undo cell operation|
|`Alt+Up`|`Ctrl+Shift+Up`|Move cell up|
|`Alt+Down`|`Ctrl+Shift+Down`|Move cell down|
|`Ctrl+Shift+-`|`Ctrl+Shift+-`|Split cell at cursor (edit mode)|
|—|`Shift+M`|Merge selected cells|

## Edit Mode

|VS Code|Jupyter|Action|
|---|---|---|
|`Tab`|`Tab`|Completion, or indent|
|`Shift+Tab`|`Shift+Tab`|Dedent (VS Code) / signature tooltip (Jupyter)|
|`Ctrl+Space`|`Shift+Tab`|Trigger suggestions / docstring|
|`Ctrl+/`|`Ctrl+/`|Toggle comment on selection|
|`Esc`|`Esc` or `Ctrl+M`|Back to command mode|

## Custom Bindings for Run and Insert Typed Cell

Neither editor ships a "run this cell and give me a cell of the opposite type" command, but VS Code's `runCommands` lets you chain the two. Open the command palette, choose **Preferences: Open Keyboard Shortcuts (JSON)**, and add:

```json
{
  "key": "alt+m",
  "command": "runCommands",
  "args": {
    "commands": [
      "notebook.cell.execute",
      "notebook.cell.insertMarkdownCellBelow"
    ]
  },
  "when": "notebookEditorFocused"
},
{
  "key": "alt+j",
  "command": "runCommands",
  "args": {
    "commands": [
      "notebook.cell.execute",
      "notebook.cell.insertCodeCellBelow"
    ]
  },
  "when": "notebookEditorFocused"
}
```

Both insert commands drop you into edit mode in the new cell, so one chord gets you all the way there.

Use `notebook.cell.execute` rather than `notebook.cell.executeAndInsertBelow`, or you'll end up with a stray empty cell before the one you asked for.

To insert without running, bind the insert commands on their own:

```json
{
  "key": "ctrl+alt+m",
  "command": "notebook.cell.insertMarkdownCellBelow",
  "when": "notebookEditorFocused && !inputFocused"
},
{
  "key": "ctrl+alt+j",
  "command": "notebook.cell.insertCodeCellBelow",
  "when": "notebookEditorFocused && !inputFocused"
}
```
