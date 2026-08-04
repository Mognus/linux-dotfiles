# Hyprland

`SUPER` is the main desktop modifier.

## Does

- Keyboard-first window control
- Numbered workspaces for daily contexts
- Scratchpads for temporary apps
- `awww` wallpaper setup
- Hyprlock session locking
- Polkit authentication prompts through the GNOME agent
- Quickshell desktop widgets and quick settings

## Desktop Role

Hyprland runs the desktop, `awww` sets the wallpaper, Quickshell provides the
desktop widgets, and Hyprlock locks the session.

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

## Appearance

- `SUPER+W` - Pick a wallpaper
- `SUPER+Shift+W` - Pick the Black, White, Pink, or Cyan palette
- `SUPER+=/-` - Increase/decrease window opacity

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
- `SUPER+Alt+[/]` - Move window to previous/next workspace

## Scratchpads

- `SUPER+Ctrl+Return` - Terminal scratchpad
- `SUPER+Ctrl+B` - Firefox scratchpad
- `SUPER+Ctrl+D` - Discord scratchpad
- `SUPER+Ctrl+N` - Notes scratchpad
- `SUPER+Ctrl+F` - File manager scratchpad

## Desktop Widgets

- `SUPER+Ctrl+T` - Toggle both Quickshell Tux widgets
- `SUPER+Ctrl+G` - Toggle Quickshell quick settings
- `SUPER+Ctrl+P`, then `B/P` - Toggle bottom bar/workspace HUD

## Music

- `SUPER+Ctrl+M` - Toggle YouTube Music

## Workflow

Start from the launcher or terminal, keep long-running work on workspaces, pull scratchpads in only when needed, and move focus with `H/J/K/L`.
