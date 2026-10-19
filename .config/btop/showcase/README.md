# btop

Retro system monitor using btop's built-in TTY mode. Configuration lives in
`../btop.conf` and is linked to `~/.config/btop/btop.conf` by Home Manager or Stow.

## Settings

- `force_tty = true` forces 16 colors, TTY graph symbols and square corners.
- `theme_background = true` uses ANSI black for the background.
- `proc_sorting = "memory"` keeps the existing process sorting preference.
- `save_config_on_exit = false` keeps temporary menu changes out of the dotfiles.

## Theme integration

TTY mode ignores custom btop themes. Instead, `appearancectl` writes Alacritty's
16 ANSI colors from the selected palette, so an already-running btop changes
colors when the desktop theme changes. No btop theme file or reload is needed.

| ANSI color | Palette value |
| --- | --- |
| Black | Terminal background |
| Bright black | Muted text |
| Red / bright red | Danger |
| Green / bright green | Success |
| Yellow / bright yellow | Warning |
| Blue / bright blue | Secondary |
| Magenta / bright magenta | Violet |
| Cyan / bright cyan | Accent |
| White / bright white | Terminal foreground |

Terminal background/foreground overrides are respected. In particular, Light
Gray keeps its dark terminal. This ANSI palette also applies to other terminal
applications. In a real Linux virtual console, btop still works in TTY mode,
but Alacritty's palette does not configure that console's colors.
