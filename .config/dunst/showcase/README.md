# Notifications

Dunst handles desktop notifications.

## Does

- Shows notifications in the top-right
- Keeps normal messages short-lived
- Keeps critical messages visible
- Uses urgency colors for priority

## Keybinds

None.

## Workflow

Let normal notifications disappear automatically. Treat critical notifications as things that need manual attention.

Edit `dunstrc.template` for layout and behavior. The theme switcher replaces its
color placeholders with values from `.config/themes/palettes/` and writes
`~/.local/state/dotfiles-theme/dunstrc`. Hyprland starts Dunst with that generated
file; switching themes regenerates it and reloads Dunst.
