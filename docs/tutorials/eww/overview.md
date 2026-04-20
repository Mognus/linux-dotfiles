# EWW Overview

EWW is used here as a lightweight widget layer for custom interface pieces.

## Main files

- `.config/eww/eww.yuck`
- `.config/eww/eww.scss`

## What this topic covers

- Widget structure
- Styling and visual consistency
- Script-driven dynamic data
- How the widgets fit into the desktop workflow

## Current setup details

Right now the EWW layer is intentionally very small and focused.

### Widget purpose

The current widget is a floating `tux-angel` overlay anchored in the bottom-right area of the screen.

It is:

- non-exclusive
- non-focusable
- rendered as an overlay

### Interaction

The widget visibility is driven through EWW state and helper scripts:

- `tux-visible` controls whether it is shown
- hover triggers `~/.config/eww/scripts/tux-hide.sh`
- a Hyprland keybind triggers `~/.config/eww/scripts/tux-toggle.sh`

### Styling

The SCSS stays intentionally minimal:

- transparent background
- no border
- no box shadow

That makes the animated image feel like a desktop accent instead of a full widget panel.

## Workflow idea

Widgets should support the desktop, not compete with it. The goal is to expose useful state and shortcuts while keeping the layout intentional and maintainable.
