# Neovim Setup

Neovim is managed from `~/dotfiles/.config/nvim`.

## Layout

- `init.lua` loads the core modules.
- `lua/core/options.lua` contains editor defaults.
- `lua/core/ui.lua` contains global UI settings.
- `lua/core/plugins.lua` declares and configures `vim.pack` plugins.
- `lua/core/keymaps.lua` contains global keymaps.
- `lua/core/lsp.lua` contains language server and diagnostic behavior.
- `lua/core/format.lua` configures on-demand formatting through `conform.nvim`.
- `lua/core/git.lua` implements a custom Snacks picker for Git status across the root repo and its submodules.

## Features

- VSCode-like explorer through `nvim-tree`.
- File search, grep, LSP pickers, and diagnostics through `snacks.nvim`.
- TypeScript/JavaScript LSP through `typescript-language-server`.
- ESLint diagnostics and code actions through `vscode-eslint-language-server`.
- Rust LSP through `rust-analyzer`.
- Completion through `blink.cmp`.
- On-demand formatting through `conform.nvim` (Prettier for JS/TS, `rustfmt` for Rust).
- Auto-pairs through `nvim-autopairs`.
- Highlighted `TODO`, `FIXME`, and `NOTE` comments through `todo-comments.nvim`.
- Inline Git hunks through `gitsigns.nvim`.
- Statusline through `lualine.nvim`.
- Mouse support and system clipboard integration are enabled.

## Daily Keys

| Key | Action |
| --- | --- |
| `F1` | Show keymap help |
| `Ctrl+B` | Toggle file explorer |
| `Ctrl+T` | New tab |
| `Ctrl+Q` | Close tab |
| `Ctrl+J` | Previous tab |
| `Ctrl+K` | Next tab |
| `Ctrl+F` | Grep files |
| `Ctrl+P` | Find files |
| `Ctrl+Shift+M` | Show project problems |
| `Ctrl+Shift+O` | Show symbols in current file |
| `Ctrl+Shift+G` | Show Git workspace status, including submodules |
| `Alt+Shift+G` | Show Git diff/hunks |
| `Alt+u` | Previous function or class |
| `Alt+d` | Next function or class |
| `F12` | Go to definition |
| `Shift+F12` | Find references |
| `F24` | Find references fallback when the terminal encodes `Shift+F12` as `F24` |
| `F2` | Rename symbol |
| `Ctrl+.` | Code action |
| `Ctrl+Shift+I` | Format file |
| `K` | Show hover information |
| `F4` | Show problem under cursor |
| `F8` | Next problem |
| `Shift+F8` | Previous problem |
| `F20` | Previous problem fallback when the terminal encodes `Shift+F8` as `F20` |
| `Ctrl+Space` | Trigger completion manually |
| `Tab` | Next completion item |
| `Shift+Tab` | Previous completion item |
| `Enter` | Accept completion item |
| `Esc` | Close completion menu |
| `Alt+n` | Next Git hunk |
| `Alt+p` | Previous Git hunk |
| `Alt+h` | Preview Git hunk |
| `Alt+s` | Stage Git hunk |
| `Alt+r` | Reset Git hunk |

## Workflows

### Project Navigation

Use `Ctrl+B` to open or close the file explorer. `Enter` opens a file and closes the explorer; `t` adds it as a background tab and keeps the explorer open. Use `j`/`k` to browse, `l`/`h` to open and close directories, and `/` to fuzzy-filter the tree. Prefix a query with `'` for an exact match, `^` for a prefix match, or append `$` for a suffix match. Git-ignored files are excluded; toggle them with `I`.

Git state is shown with simple markers:

- `M` modified
- `S` staged
- `?` untracked
- `D` deleted
- `R` renamed
- `U` conflict
- `I` ignored

### Search

Use `Ctrl+F` for project-wide grep and `Ctrl+P` to find files by name. In the Snacks picker, toggle ignored files with `Alt+i` when you need to search `node_modules` or other ignored paths. Toggle hidden files with `Alt+h` when dotfiles are missing from the results.

### TypeScript Navigation

Use `F12` on a symbol to jump to its definition. Use `Shift+F12` to list references. Some terminal encodings report `Shift+F12` as `F24`, so both are mapped.

Use `K` for hover information and `Ctrl+.` for TypeScript, ESLint, Go, or Rust code actions. ESLint format-on-save and fix-on-save are intentionally disabled.

### Diagnostics

Use `Ctrl+Shift+M` to open the Problems picker. Use `F4` to expand the problem under the cursor. Use `F8` and `Shift+F8` to move through problems. Some terminal encodings report `Shift+F8` as `F20`, so both are mapped.

### Completion

Completion opens automatically while typing. Use `Ctrl+Space` to trigger it manually. Use `Tab` and `Shift+Tab` to move through suggestions, `Enter` to accept, and `Esc` to close the menu.

### Git Hunks

Git hunks are changed line blocks compared to Git. `gitsigns.nvim` shows them in the sign column:

- `+` added line
- `~` changed line
- `-` deleted line
- `?` untracked line

Use `Alt+n` and `Alt+p` to move between hunks. Use `Alt+h` to preview the current hunk, `Alt+s` to stage it, and `Alt+r` to reset it.

Use `Ctrl+Shift+G` to open a custom Snacks Git status picker for the root repo and recursive submodules. Use `Alt+Shift+G` to open changed hunks in the Snacks Git diff picker for the current repo.

## Buffers

A buffer is a loaded file in Neovim memory. A window is only a view onto a buffer, so multiple windows can show the same buffer or different buffers.

Opening one file loads that file as a buffer. Referenced or imported files are not automatically opened as buffers, but the LSP can still know about them through the project root. Jumping to a definition in another file loads that target file as a new buffer.

Useful commands:

- `:ls` - List open buffers
- `:buffers` - List open buffers
- `:copen` - Open quickfix list
- `:cclose` - Close quickfix list

## Plugin State

`vim.pack` stores installed plugins under `~/.local/share/nvim/site/pack/core/opt` and pins them in `nvim-pack-lock.json`.

When removing a plugin, remove it from `plugins.lua`, remove its lock entry, and delete its directory under `site/pack/core/opt`. Otherwise `vim.pack` may repair the lockfile and add the old plugin back.
