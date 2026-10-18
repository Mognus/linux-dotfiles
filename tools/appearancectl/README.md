# appearancectl

Local Rust tool for desktop themes and terminal adjustments. Rust 1.89+, Cargo
and Make are needed to build it. Theme changes use `dconf` for GTK preferences
and optionally `notify-send` to announce the selected theme.

```sh
make -C ~/dotfiles/tools/appearancectl
make -C ~/dotfiles/tools/appearancectl check
```

The executable lives at `tools/appearancectl/bin/appearancectl`, beside its
source project. `bin/` and `target/` are ignored by Git. Rebuild after source
changes, and build once on each new machine. `Cargo.lock` is tracked.

```sh
tools/appearancectl/bin/appearancectl init
tools/appearancectl/bin/appearancectl get
tools/appearancectl/bin/appearancectl restore
tools/appearancectl/bin/appearancectl theme .config/themes/palettes/light-gray.json
tools/appearancectl/bin/appearancectl terminal opacity 0.85
tools/appearancectl/bin/appearancectl terminal font-size 20
tools/appearancectl/bin/appearancectl terminal padding 12
tools/appearancectl/bin/appearancectl terminal reset
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

Quickshell calls `theme` directly; Hyprland autostart and `install.sh` call
`restore`. The former `theme-switcher.sh` is no longer needed.

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
- `gtk.rs` — generate GTK CSS and set GTK preferences through `dconf`.

Integration tests use a temporary `HOME` and fake `dconf`/`notify-send` programs,
so they never change the running desktop's preferences.
