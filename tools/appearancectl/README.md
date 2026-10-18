# appearancectl

Local Rust writer for the shared Alacritty state file. No Nix package or
script runner is required. Rust 1.89+, Cargo and Make are needed to build it.

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
tools/appearancectl/bin/appearancectl theme .config/themes/palettes/light-gray.json
tools/appearancectl/bin/appearancectl terminal opacity 0.85
tools/appearancectl/bin/appearancectl terminal font-size 20
tools/appearancectl/bin/appearancectl terminal padding 12
tools/appearancectl/bin/appearancectl terminal reset
```

All commands use `$THEME_STATE_DIR/alacritty.toml` when set; otherwise they use
`$XDG_STATE_HOME/dotfiles-theme/alacritty.toml`, defaulting to
`~/.local/state/dotfiles-theme/alacritty.toml`. `get` only reads and emits JSON.
Other commands lock `alacritty.lock`, read the current TOML, update only their
fields and atomically replace the file. Unknown fields and comments survive.
The lock file stays at the same path while the TOML is replaced.

`theme-switcher.sh` calls `theme` for colors and still generates GTK and
Quickshell colors itself. Settings > Appearance > Adjustments calls the
`terminal` commands. Theme changes preserve opacity, font size and padding;
terminal changes preserve the colors. Defaults are 0.93 opacity, 20 pt and
12 px padding. Reset changes only those three settings.

Alacritty imports the shared file and reloads changes live. Its main config
must not override these imported fields. Sliders save on release; keyboard
and wheel changes save through the same writer. Values remain saved across
shell restarts and theme changes.
