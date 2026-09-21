# Hyprland

`SUPER` is the main desktop modifier.

## Does

- Keyboard-first window control
- Numbered workspaces for daily contexts
- Scratchpads for temporary apps
- `awww` wallpaper setup
- Hyprlock session locking, automatically through Hypridle after thirty idle minutes
- Clipboard history with image thumbnails through cliphist and Rofi
- Volume and media keys through wpctl and playerctl
- Polkit authentication prompts through the GNOME agent
- Quickshell desktop widgets and quick settings

## Desktop Role

Hyprland runs the desktop, `awww` sets the wallpaper, Quickshell provides the
desktop widgets, Hyprlock locks the session, and Hypridle locks it after thirty
idle minutes, turns the monitor off five minutes later, and locks before suspend.

## Config

- `hyprland.lua` - Main Hyprland config
- `lua/` - Split Lua modules for monitors, binds, workspaces, and appearance
- `hypridle.conf` - Idle timeouts and suspend hooks
- `scripts/` - Rofi pickers for wallpapers, palettes, and clipboard history

## Apps

- `SUPER+Return` - Alacritty terminal
- `SUPER+B` - Firefox
- `SUPER+Space` - Rofi app launcher
- `SUPER+Ctrl+Space` - Rofi window switcher

Apps, windows, wallpapers, palettes, and clipboard history use separate Rofi
menus with one shared theme. There are no mode tabs or combined search; shell commands run in the terminal.
All menus use the same fixed nine-row layout and open without compositor animations.
The window switcher uses Rofi's built-in window mode and shows window titles.

## Session

- `SUPER+Escape` - Lock
- `SUPER+F1` - Suspend
- `SUPER+S` - Area screenshot to file
- `SUPER+Ctrl+S` - Area screenshot to clipboard
- `SUPER+Ctrl+V` - Toggle recording

## Clipboard

- `SUPER+V` - Pick an entry from the clipboard history
- `SUPER+Shift+V` - Wipe the clipboard history

Every clipboard change is stored by cliphist. Image entries show a thumbnail
next to the row; text entries show their first line.

## Audio

- `SUPER+=/-` - Volume up/down
- `SUPER+0` - Toggle mute
- `XF86Audio*` keys - Volume, mute, microphone mute, play/pause, next, previous

Audio bindings also work on the lock screen. The Quickshell bar shows the level.

## Appearance

- `SUPER+W` - Pick a wallpaper
- `SUPER+Ctrl+W` - Pick the Black, White, Pink, or Cyan palette
- `SUPER+Shift+=/-` - Increase/decrease terminal opacity

## Windows

- `SUPER+Q` - Close window
- `SUPER+F` - Fullscreen
- `SUPER+Shift+Space` - Toggle floating
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
