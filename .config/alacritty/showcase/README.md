# Alacritty

Alacritty is the terminal emulator — GPU-accelerated and minimal, configured in TOML (`alacritty.toml`). Tabs and splits are left to tmux; the terminal stays a thin, fast layer.

## Does

- GPU-accelerated rendering with low input latency
- Minimal chrome (no window decorations, slight transparency)
- Vi mode for scrollback navigation and buffer search

## Keybinds

- `Ctrl+Alt+/` - search forward, `Ctrl+Alt+?` - search backward (only outside Vi mode)
- `Ctrl+Shift+Space` - toggle Vi mode; inside it use `/` `?` `n` `N` natively
- `Super+Alt+T/Q/J/K` - create/close/switch tmux windows
- `Super+Alt+S/N/R/X` - choose/create/rename/close tmux sessions
- `Super+Alt+Shift+H/J/K/L` - resize tmux panes

## Workflow

Run tmux inside Alacritty for sessions, tabs, and splits. Alacritty forwards the
`Super+Alt` combinations as terminal sequences understood by the tmux config.
Use Vi mode to navigate scrollback without reaching for the mouse.
