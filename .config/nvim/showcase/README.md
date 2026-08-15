# Neovim Setup

Neovim is managed from `~/dotfiles/.config/nvim`.

It is deliberately small: five plugins, close to plain Vim plus a language
server. Anything requiring a rich UI — file tree, Git panel, agent threads —
happens in Zed instead (`~/dotfiles/.config/zed`).

## Layout

- `init.lua` loads the core modules.
- `lua/core/options.lua` contains editor defaults.
- `lua/core/ui.lua` contains syntax and LSP highlight colors.
- `lua/core/plugins.lua` declares and configures `vim.pack` plugins.
- `lua/core/keymaps.lua` contains global keymaps.
- `lua/core/lsp.lua` contains language server and diagnostic behavior.
- `lua/core/format.lua` configures on-demand formatting through `conform.nvim`.

## Plugins

| Plugin | Purpose |
| --- | --- |
| `snacks.nvim` | Pickers: files, grep, symbols, diagnostics, keymaps |
| `blink.cmp` | Completion |
| `nvim-treesitter` | Syntax highlighting and indentation |
| `gitsigns.nvim` | Git hunk markers in the sign column |
| `conform.nvim` | On-demand formatting (Prettier for JS/TS, `rustfmt` for Rust) |

Commenting (`gc`/`gcc`), surround-style editing, and diagnostic navigation
(`]d`/`[d`) come from Neovim 0.12 itself and need no plugin.

Language servers: `typescript-language-server`, `vscode-eslint-language-server`,
`tailwindcss-language-server`, `svelteserver`, `gopls`, `rust-analyzer`.

Mouse support and system clipboard integration are enabled.

## Daily Keys

| Key | Action |
| --- | --- |
| `F1` | Show keymap help |
| `Ctrl+T` | New tab |
| `Ctrl+Q` | Close tab |
| `Ctrl+J` | Previous tab |
| `Ctrl+K` | Next tab |
| `Ctrl+F` | Grep files |
| `Ctrl+P` | Find files |
| `Ctrl+Shift+M` | Show project problems |
| `Ctrl+Shift+O` | Show symbols in current file |
| `Alt+Shift+G` | Show Git diff/hunks |
| `F12` / `gd` | Go to definition |
| `Shift+F12` / `grr` | Find references |
| `F2` / `grn` | Rename symbol |
| `Ctrl+.` / `gra` | Code action |
| `Ctrl+Shift+I` | Format file |
| `Ctrl+Shift+K` | Toggle comment |
| `K` | Show hover information |
| `F3` | Toggle inlay hints |
| `F4` | Show problem under cursor |
| `F8` / `]d` | Next problem |
| `Shift+F8` / `[d` | Previous problem |
| `Ctrl+Space` | Trigger completion manually |
| `Tab` | Next completion item |
| `Shift+Tab` | Previous completion item |
| `Enter` | Accept completion item |
| `Esc` | Close completion menu |
| `Alt+n` / `]c` | Next Git hunk |
| `Alt+p` / `[c` | Previous Git hunk |
| `Alt+e` | Preview Git hunk |

`gd`, `]c` and `[c` mirror Zed's vim mode so both editors share one idiom.

## Workflows

### Project Navigation

There is no file tree. Use `Ctrl+P` to find files by name and `Ctrl+F` for
project-wide grep; both open a Snacks picker. For directory browsing, the
built-in `netrw` is still available through `:Explore`.

In the Snacks picker, toggle ignored files with `Alt+i` when you need to search
`node_modules` or other ignored paths. Toggle hidden files with `Alt+h` when
dotfiles are missing from the results.

### TypeScript Navigation

Use `F12` or `gd` on a symbol to jump to its definition. Use `Shift+F12` or the
built-in `grr` to list references.

Use `K` for hover information and `Ctrl+.` for TypeScript, ESLint, Go, or Rust
code actions. ESLint format-on-save and fix-on-save are intentionally disabled.

### Diagnostics

Use `Ctrl+Shift+M` to open the Problems picker. Use `F4` to expand the problem
under the cursor. Use `F8` and `Shift+F8`, or the built-in `]d` and `[d`, to
move through problems.

### Completion

Completion opens automatically while typing. Use `Ctrl+Space` to trigger it
manually. Use `Tab` and `Shift+Tab` to move through suggestions, `Enter` to
accept, and `Esc` to close the menu.

### Git Hunks

Git hunks are changed line blocks compared to Git. `gitsigns.nvim` shows them in
the sign column:

- `+` added line
- `~` changed line
- `-` deleted line
- `?` untracked line

Use `Alt+n`/`]c` and `Alt+p`/`[c` to move between hunks, and `Alt+e` to preview
the current one. Staging and committing happen in Zed's Git panel or in `git`
directly.

## Buffers

A buffer is a loaded file in Neovim memory. A window is only a view onto a
buffer, so multiple windows can show the same buffer or different buffers.

Opening one file loads that file as a buffer. Referenced or imported files are
not automatically opened as buffers, but the LSP can still know about them
through the project root. Jumping to a definition in another file loads that
target file as a new buffer.

Useful commands:

- `:ls` - List open buffers
- `:buffers` - List open buffers
- `:copen` - Open quickfix list
- `:cclose` - Close quickfix list

## Plugin State

`vim.pack` stores installed plugins under
`~/.local/share/nvim/site/pack/core/opt` and pins them in
`nvim-pack-lock.json`.

When removing a plugin, remove it from `plugins.lua`, remove its lock entry, and
delete its directory under `site/pack/core/opt`. Otherwise `vim.pack` may repair
the lockfile and add the old plugin back.
