# Theme System

Centralized dark/light theming for Hyprland, Waybar and future tools.

## Structure

```
~/.config/theme/
├── active              -> dark.conf | light.conf   (symlink)
├── dark.conf           ← Hyprland border vars (dark wallpaper)
├── light.conf          ← Hyprland border vars (light wallpaper)
├── waybar.css          -> waybar-dark.css | waybar-light.css   (symlink)
├── waybar-dark.css     ← Waybar CSS custom properties (dark)
├── waybar-light.css    ← Waybar CSS custom properties (light)
└── switch              ← switch script
```

`~/.config/waybar/style.css` is the single structural Waybar stylesheet.
It pulls colors via `@import "../theme/waybar.css"` and uses `var(--wb-*)` throughout.

`~/.config/hypr/hyprland.conf` sources `~/.config/theme/active` for border color variables.

## Switching

```bash
~/.config/theme/switch dark
~/.config/theme/switch light
```

Updates both symlinks (`active` and `waybar.css`) and reloads Hyprland + Waybar.

## Adding a new tool

1. Create `~/.config/theme/<tool>-dark.css` / `<tool>-light.css` with the tool's variables
2. Add a symlink line to `switch`: `ln -sf "<tool>-$THEME.css" ~/.config/theme/<tool>.css`
3. Have the tool's config `@import` or `source` `~/.config/theme/<tool>.css`
