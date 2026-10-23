# appearancectl

Local Rust tool for desktop themes and terminal adjustments. Nix builds and tests
it automatically as part of the shared Home Manager configuration on both hosts:

```sh
sudo nixos-rebuild switch --flake ~/dotfiles/nix
```

Home Manager installs the package and links `~/.local/bin/appearancectl` directly
to its binary in the Nix store. Hyprland and Quickshell keep using that fixed
path. No manual build is needed after cloning or pulling source changes; apply
the Nix configuration instead. `Cargo.lock` pins the Rust dependencies, and the
package supplies `dconf`, `notify-send` and `tmux` on its runtime PATH.

For development outside the Nix build, Rust 1.89+, Cargo and Make are needed:

```sh
make -C tools/appearancectl
make -C tools/appearancectl check
```

The manual build writes `tools/appearancectl/bin/appearancectl`; `bin/` and
`target/` are ignored by Git. This development binary does not replace the
Nix-managed one; run it explicitly to test local source changes.

```sh
appearancectl init
appearancectl get
appearancectl restore
appearancectl theme .config/themes/palettes/light-gray.json
appearancectl terminal opacity 0.85
appearancectl terminal font-size 20
appearancectl terminal padding 12
appearancectl terminal reset
```

All state lives in `~/.local/state/dotfiles-theme`, matching Quickshell's shared
`ThemePaths.qml`. There are no state directory overrides. Commands emit the
current terminal settings as JSON; `get` only reads.

`theme <palette.json>` validates a palette, updates Alacritty colors, writes
`colors.json` for Quickshell and `gtk.css` for GTK, applies GTK preferences
through `dconf`, then saves the palette's filename stem in `current`. A failed
`dconf` command is reported as an error; an unavailable notification is ignored.
`restore` reads `current` and loads that palette from `~/.config/themes/palettes`
without announcing it. On a fresh setup it uses `retro-dark.json`.

Quickshell calls `theme` directly; Hyprland autostart calls `restore`. The former
`theme-switcher.sh` is no longer needed.

Quickshell's bottom bar uses the palette's `bar` color (`#AARRGGBB`): darker on
light themes and lighter on dark themes, with its existing transparency kept.
The tmux status background follows the terminal directly (`bg=default`); it has
no separate generated style. OpenCode keeps its terminal-derived `system` theme.

After applying a theme, attached tmux terminals are queried for their actual
foreground/background colors after 250 ms and again after one second. This
refreshes tmux's cached colors after Alacritty reloads, allowing OpenCode's
`system` theme to update its solid surfaces without restarting. No terminal
colors are set by these queries. Without an attached tmux client this is skipped.

All writes hold the same `alacritty.lock`, including complete theme changes.
Each state file is replaced atomically, but the complete set of files and dconf
preferences is not a single transaction. Unknown Alacritty fields and comments
survive; extra palette fields are preserved in `colors.json`.

Settings > Appearance > Adjustments calls the `terminal` commands.
Theme changes preserve opacity, font size and padding;
terminal changes preserve the colors. Defaults are 0.93 opacity, 20 pt and
12 px padding. Reset changes only those three settings.

Theme changes also generate Alacritty's normal/bright ANSI palette. btop runs
with `force_tty = true` and uses these 16 terminal colors directly, so it follows
theme changes without a separate btop theme file or a process restart. Other
ANSI-colored terminal applications use the same palette. See
[`btop` settings](../../.config/btop/showcase/README.md) for the color mapping.

Alacritty imports the shared file and reloads changes live. Its main config
must not override these imported fields. Sliders save on release; keyboard
and wheel changes save through the same writer. Values remain saved across
shell restarts and theme changes.

## Source layout

- `main.rs` — parse commands and call the responsible module.
- `paths.rs` — fixed paths, shared write lock and atomic state-file replacement.
- `terminal.rs` — refresh attached tmux clients through terminal color queries.
- `palette.rs` — read and validate palette JSON.
- `theme.rs` — coordinate a complete theme change or restore the saved theme.
- `alacritty.rs` — preserve and update terminal TOML, including slider defaults.
- `ansi_colors.rs` — map palette roles to the 16 ANSI colors used by terminal apps.
- `gtk.rs` — generate GTK CSS and set GTK preferences through `dconf`.

Integration tests use a temporary `HOME` and fake `dconf`/`notify-send` programs,
so they never change the running desktop's preferences.
