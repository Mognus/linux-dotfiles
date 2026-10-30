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
- `Alt-C` - Jump to directory through FZF
- `Ctrl+W` - Delete the previous word segment, stopping at punctuation
- `Alt+Backspace` - Delete the previous whitespace-delimited word or path
- `Ctrl+U` - Delete back to the beginning of the line, preserving text to the right

`keybindings.zsh` defines the two word-deletion rules independently, without
changing word navigation globally. Both common Alt+Backspace sequences are bound.

## Configuration

History is stored in `~/.local/state/zsh/history` and shared between shells.
`~/.zshenv` sets `ZDOTDIR` to `~/.config/zsh` and exports the editor and PATH;
`.zshrc` handles interactive configuration. Fish history is not imported.

`prompt.zsh` keeps the former Fish appearance: an empty line, an abbreviated
bright-green path, then a cyan `$` (red after a failed command). Accepted commands
are redrawn without the path, with their submission time on the right.

### GitHub completion

`plugins/gh-repos.zsh` adds your configured GitHub account's repositories
to `gh repo clone <Tab>`. Other positions, including flags and the destination
directory, use the official GitHub CLI completion.

The first lookup fetches up to 1,000 owned repositories (including private repos
the account can access). Results are cached per host/account for five minutes in
`~/.cache/zsh/gh-repos`, with private permissions. Refreshes time out after five
seconds and fall back to old data when offline. No repository lookup runs at shell
startup. Authentication is managed through `gh auth login` / `gh auth switch`;
the completion reads the configured account locally.

## Workflow

Use Zsh for interactive shell work and FZF for history, file, and directory search.
