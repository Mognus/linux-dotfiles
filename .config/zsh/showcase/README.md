# Shell

Zsh is the daily shell, without a framework.

`plugins/completion.zsh` configures native Zsh completion without a framework:
case-insensitive substring matching, grouped descriptions and immediate menu
selection. For example, `uk<Tab>` selects a matching `cover-letter-ukj-jena.pdf`.
Tab and Shift+Tab cycle forward/backward through only the matching candidates;
Enter accepts a menu selection without executing the command. Ordinary shell
globs remain case-sensitive. FZF handles its search shortcuts, not Tab.
Standalone `zsh-autosuggestions` and `zsh-syntax-highlighting` add history
suggestions and command highlighting; Home Manager links the Nix-built plugins.
The entire `~/.config/zsh` directory links into the dotfiles repository; external
plugins live separately in `~/.local/share/zsh/plugins`. The bootstrap file
`~/.zshenv` is linked separately so Zsh can discover `ZDOTDIR`.
The completion plugin initializes `compinit`; do not initialize it a second time.
Its dumpfile lives under `~/.cache/zsh`.

## Does

- Loads local user binaries into `PATH`
- Enables FZF keybinds when available

## Keybinds

- `Ctrl+R` - Search command history through FZF
- `Ctrl+T` - Search files through FZF
- `Alt+C` - Jump to directory through FZF
- `Ctrl+W` - Delete the previous word (native Zsh behavior)
- `Ctrl+U` - Delete the whole line (native Zsh Emacs binding)

FZF uses its default shortcuts without a custom shell leader. Other Emacs editing
bindings remain unchanged. Tab completion keeps its separate menu configuration.

## Configuration

History is stored in `~/.local/state/zsh/history` and shared between shells.
`~/.zshenv` sets `ZDOTDIR` to `~/.config/zsh` and exports the editor and PATH;
`.zshrc` handles interactive configuration. Fish history is not imported.

`prompt.zsh` sets `PS1` to an empty line, the full bright-green working directory
(`~` for home), then a cyan `$` on the next line (`#` for privileged shells).
The symbol turns red after errors. No username, hostname, path abbreviation or
transient redraw is added. `RPS1` shows the time in gray on the right when the
prompt is drawn; it is not a continuously updating clock. Both prompts use native
Zsh escapes without custom hooks.

## Workflow

Use Zsh for interactive shell work and FZF for history, file, and directory search.

`dark` selects Gruvbox Dark in Alacritty and native GTK dark mode; `light` selects
Gruvbox Light and GTK light mode. Both are short functions in `.zshrc`, not a
theme manager. They copy a static color file and leave terminal settings alone.
The selected `alacritty/colors.toml` is tracked in Git; a clean checkout starts dark.
