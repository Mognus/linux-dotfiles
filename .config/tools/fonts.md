# Fonts

Fonts are part of the terminal and desktop experience.

## Installed Fonts

- `ttf-meslo-nerd` - primary Nerd Font
- `ttf-jetbrains-mono-nerd` - secondary Nerd Font

## Fontconfig

Fontconfig lives at `.config/fontconfig/fonts.conf`.

## Does

- Keeps font fallback predictable
- Supports terminal icons and Nerd Font glyphs
- Helps Alacritty, Waybar, and shell tooling render consistently

## Workflow

Use Nerd Fonts for terminals and status UI. Keep fallback rules in fontconfig instead of patching each app independently.
