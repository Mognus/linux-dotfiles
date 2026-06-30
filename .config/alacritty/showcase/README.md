# Alacritty

Alacritty is the terminal emulator — GPU-accelerated and minimal, configured in TOML (`alacritty.toml`). Tabs and splits are left to tmux; the terminal stays a thin, fast layer.

## Does

- GPU-accelerated rendering with low input latency
- Minimal chrome (no window decorations, slight transparency)
- Vi mode for scrollback navigation and buffer search

## Keybinds

- `Ctrl+Alt+/` - search forward, `Ctrl+Alt+?` - search backward (only outside Vi mode)
- `Ctrl+Shift+Space` - toggle Vi mode; inside it use `/` `?` `n` `N` natively

## Workflow

Run tmux inside Alacritty for sessions, tabs, and splits. Use Vi mode (or the `Ctrl+Alt+/` search) to scroll back and jump through output without reaching for the mouse.
