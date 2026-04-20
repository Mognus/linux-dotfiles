# Desktop Keybinds

The desktop uses `SUPER` as the main modifier.

## Core Apps

- `SUPER + Return`: open `alacritty`
  Command: `alacritty`
- `SUPER + B`: open `firefox`
  Command: `firefox`
- `SUPER + T`: open `tor-browser`
  Command: `tor-browser`
- `SUPER + Space`: open `rofi`
  Command: `rofi -show drun`

## Session Controls

- `SUPER + Escape`: lock the screen with `hyprlock`
  Command: `hyprlock`
- `SUPER + F1`: suspend the system
  Command: `systemctl suspend`
- `SUPER + S`: take an area screenshot and save it to `~/Pictures/Screenshots`
  Command: `grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%F_%T).png`
- `SUPER + CTRL + S`: take an area screenshot and copy it to the clipboard
  Command: `grim -g "$(slurp)" - | wl-copy`
- `SUPER + CTRL + V`: toggle screen recording through the Waybar script
  Command: `~/.config/waybar/scripts/record-toggle.sh`

## Window Controls

- `SUPER + Q`: close the active window
- `SUPER + F`: toggle fullscreen
- `SUPER + CTRL + Space`: toggle floating mode

## Focus Navigation

Focus movement is mapped to the home row:

- `SUPER + H`: move focus left
- `SUPER + L`: move focus right
- `SUPER + K`: move focus up
- `SUPER + J`: move focus down

## Move Windows

Move the active window inside the current layout:

- `SUPER + CTRL + H`: move window left
- `SUPER + CTRL + L`: move window right
- `SUPER + CTRL + K`: move window up
- `SUPER + CTRL + J`: move window down

Move the active window to another workspace:

- `SUPER + CTRL + Left`: move window to previous workspace
- `SUPER + CTRL + Right`: move window to next workspace
- `SUPER + CTRL + 1..5`: move window directly to workspace `1..5`

## Workspaces

Cycle workspaces:

- `SUPER + Left`: previous workspace
- `SUPER + Right`: next workspace

Jump directly:

- `SUPER + 1`: workspace `1` (`CODE`)
- `SUPER + 2`: workspace `2` (`TEST`)
- `SUPER + 3`: workspace `3` (`FLOW`)
- `SUPER + 4`: workspace `4` (`EXTRA`)
- `SUPER + 5`: workspace `5`

There is also a second layer of direct workspace shortcuts:

- `SUPER + CTRL + C`: workspace `1`
- `SUPER + CTRL + Q`: workspace `2`
- `SUPER + CTRL + F`: workspace `3`
- `SUPER + CTRL + A`: workspace `4`

## Special Workspaces

These bindings toggle named special workspaces:

- `SUPER + CTRL + Return`: terminal scratchpad
- `SUPER + CTRL + B`: Firefox scratchpad
- `SUPER + CTRL + D`: Discord scratchpad
- `SUPER + CTRL + N`: Notes scratchpad

## Music Submap

The music workspace uses a small submap:

- `SUPER + CTRL + M`: enter music submap
- `M`: toggle the YouTube Music special workspace
- `L`: toggle the local `cmus` special workspace
- `Escape`: leave the submap

## Extra Toggle

- `CTRL + SUPER + SHIFT + T`: toggle the EWW `tux` widget
  Command: `~/.config/eww/scripts/tux-toggle.sh`

## Recommendation

The highest-value binds to memorize first are:

- terminal
- rofi
- focus movement
- close window
- workspace switching
- terminal scratchpad

Once those feel natural, the scratchpads and music submap become much easier to integrate into daily use.
