# Shell

Zsh is the daily shell, without a framework.

Completion uses Zsh's built-in `compinit` and `zsh/complist`, initialized in
`.zshrc`. Tab completes the current prefix and opens a selection menu when
there are multiple candidates; Tab and Shift+Tab cycle, and Enter accepts.
Candidates are not listed while typing. Matching uses Zsh's defaults, not
case-insensitive substring matching. FZF handles its search shortcuts, not Tab.
Standalone `zsh-autosuggestions` and `zsh-syntax-highlighting` add
history suggestions and command highlighting; Home Manager links the Nix-built
plugins. The entire `~/.config/zsh` directory links into the dotfiles
repository; external plugins live separately in `~/.local/share/zsh/plugins`.
The bootstrap file `~/.zshenv` is linked separately so Zsh can discover
`ZDOTDIR`.

## Does

- Loads local user binaries into `PATH`
- Enables FZF keybinds when available

## Keybinds

- `Ctrl+R` - Search command history through FZF
- `Ctrl+T` - Search files through FZF
- `Alt+C` - Jump to directory through FZF
- `Ctrl+W` - Delete the previous word; `/` separates path components
- `Ctrl+Left` / `Ctrl+Right` - Move one word backward / forward
- `Ctrl+U` - Delete the whole line (native Zsh Emacs binding)
- `Tab` - Complete the current prefix; inside the menu, next candidate
- `Shift+Tab` - Previous candidate inside the completion menu

FZF uses its default shortcuts without a custom shell leader. Other Emacs editing
bindings remain unchanged. Tab completion uses native Zsh widgets.
`WORDCHARS` excludes `/`, so `cd .config/zsh/plugins/personal` becomes
`cd .config/zsh/plugins/` after one Ctrl+W. Other word characters stay unchanged.

## Configuration

History is stored in `~/.local/state/zsh/history` and shared between shells.
`~/.zshenv` sets `ZDOTDIR` to `~/.config/zsh` and exports the editor and PATH;
`.zshrc` handles interactive configuration. Fish history is not imported.

`modules/completion.zsh` initializes native completion before FZF loads.

`modules/keybinds.zsh` holds custom key bindings and word-boundary settings. It loads
after FZF and before syntax highlighting. `.zshrc` selects the Emacs keymap
before loading FZF; FZF supplies its own default bindings.

`modules/prompt.zsh` sets `PS1` to an empty line, the full bright-green working directory
(`~` for home), then a cyan `$` on the next line (`#` for privileged shells).
The symbol turns red after errors. No username, hostname, path abbreviation or
transient redraw is added. `RPS1` shows the time in gray on the right when the
prompt is drawn; it is not a continuously updating clock. Both prompts use native
Zsh escapes without custom hooks.

## Workflow

Use Zsh for interactive shell work and FZF for history, file, and directory search.

`dark` selects Gruvbox Dark in Alacritty and native GTK dark mode; `light` selects
Gruvbox Light and GTK light mode. Both are short functions in `modules/functions.zsh`, not a
theme manager. They copy a static color file and leave terminal settings alone.
The selected `alacritty/colors.toml` is tracked in Git; a clean checkout starts dark.
