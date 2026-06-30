# Hyprland

`SUPER` is the main desktop modifier.

## Does

- Keyboard-first window control
- Numbered workspaces for daily contexts
- Scratchpads for temporary apps
- Hyprpaper wallpaper setup
- Hyprlock session locking

## Desktop Role

Hyprland runs the desktop. Hyprpaper sets the wallpaper. Hyprlock locks the session.

## Config

- `hyprland.lua` - Main Hyprland config
- `lua/` - Split Lua modules for monitors, binds, workspaces, and appearance

## Apps

- `SUPER+Return` - Alacritty terminal
- `SUPER+B` - Firefox
- `SUPER+Space` - Rofi launcher, starts in apps and can switch to run/windows

## Session

- `SUPER+Escape` - Lock
- `SUPER+F1` - Suspend
- `SUPER+S` - Area screenshot to file
- `SUPER+Ctrl+S` - Area screenshot to clipboard
- `SUPER+Ctrl+V` - Toggle recording

## Windows

- `SUPER+Q` - Close window
- `SUPER+F` - Fullscreen
- `SUPER+Ctrl+Space` - Toggle floating
- `SUPER+H/J/K/L` - Focus left/down/up/right
- `SUPER+Ctrl+Shift+H/J/K/L` - Move window left/down/up/right
- `SUPER+Shift+H/J/K/L` - Resize window left/down/up/right

## Workspaces

- `SUPER+Ctrl+J/K` - Previous/next workspace
- `SUPER+1..9` - Go to workspace
- `SUPER+Ctrl+1..9` - Go to workspace
- `SUPER+Ctrl+Shift+1..9` - Move window to workspace
- `SUPER+Alt+[/]` - Move window to previous/next workspace and follow

## Scratchpads

- `SUPER+Ctrl+Return` - Terminal scratchpad
- `SUPER+Ctrl+B` - Firefox scratchpad
- `SUPER+Ctrl+D` - Discord scratchpad
- `SUPER+Ctrl+N` - Notes scratchpad
- `SUPER+Ctrl+F` - File manager scratchpad

## Desktop Widgets

- `Ctrl+SUPER+Shift+T` - Toggle both Quickshell Tux widgets
- `SUPER+Ctrl+G` - Toggle Quickshell quick settings

## Music

- `SUPER+Ctrl+M` - Enter music mode
- `M` - Toggle YouTube Music
- `L` - Toggle local music
- `Escape` - Leave music mode

## Workflow

Start from the launcher or terminal, keep long-running work on workspaces, pull scratchpads in only when needed, and move focus with `H/J/K/L`.
