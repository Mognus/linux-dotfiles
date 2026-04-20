# Notifications Overview

Notifications are configured to stay visible and useful without becoming visual noise.

## Main file

- `.config/dunst/dunstrc`

## What this topic covers

- Placement and sizing
- Color usage for urgency levels
- Timeout behavior
- Visual balance between readability and distraction control

## Current setup details

The notification daemon is positioned in the top-right corner and uses a compact but readable card layout.

### Layout

- width: `300`
- height: `100`
- gap size: `6`
- padding: `10`
- horizontal padding: `12`
- corner radius: `6`
- font: `MesloLGS Nerd Font 11`

### Behavior

- default timeout: `5`
- critical notifications stay visible with `timeout = 0`

### Color system

The configuration uses a dark base and changes the frame or foreground color depending on urgency:

- low: muted frame
- normal: blue accent frame
- critical: pink/red accent with stronger foreground emphasis

## Design goal

Notifications should communicate state clearly, but they should not dominate the screen. Urgent notifications must stand out immediately, while normal updates should stay restrained.
