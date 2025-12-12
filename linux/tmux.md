# tmux

## Run a program in a tmux session

### Start

```sh
tmux
```

Run your app, then detach with `Ctrl + B, then D`.
### Reattach

```sh
tmux attach
```
## Configuration

The default tmux prefix is `CTRL+B` but I rebind it to `CTRL+Space` in my `~/.config/tmux/tmux.conf` with the following.

```sh
# Set prefix to CTRL+SPACE
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# Set true color
set-option -sa terminal-overrides ",xterm*:Tc"

# Mouse support
set -g mouse on

# Toggle mouse with ^M; then report it's new status
bind-key C-m set-option -g mouse \; display-message 'Mouse #{?mouse,on,off}'

# Start window numbering at 1 instead of 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# Set new panes to open in current directory
# and bind horz/vert split to | and _
unbind '"'
unbind %
bind _ split-window -v -c "#{pane_current_path}"
bind | split-window -h -c "#{pane_current_path}"

# Set theme variant
set -g @catppuccin_flavour 'macchiato' # latte,frappe, macchiato or mocha

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'catppuccin/tmux'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.config/tmux/plugins/tpm/tpm'
```

