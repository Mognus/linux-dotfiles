# Fonts

Fonts are part of the terminal and desktop experience.

## Current Font Choices

- Alacritty: `PxPlus IBM VGA 8x16` at 20 points, set in `alacritty.toml`.
- Quickshell: `PxPlus IBM VGA 8x16`, set in `Fonts.qml`.
- Generic monospace: `PxPlus IBM VGA 8x16`, selected through fontconfig.
- Generic sans-serif: `IBM Plex Sans`, selected through fontconfig.

NixOS declares two font packages in `nix/modules/common.nix`: the PC font pack
providing IBM VGA, and IBM Plex restricted to Sans. NixOS's default font package
set is disabled.

Neovim and tmux use the terminal's font; they do not select a font themselves.

## Fontconfig

Fontconfig lives at `.config/fontconfig/fonts.conf`.

## Does

- Keeps font fallback predictable
- Gives apps predictable generic fonts; Alacritty and Quickshell also explicitly
  select the VGA font

## Workflow

Keep generic font preferences in fontconfig. An app that explicitly names a
font overrides those preferences.
