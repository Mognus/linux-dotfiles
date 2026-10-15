# Neovim Setup

Configuration lives in `~/dotfiles/.config/nvim/init.lua`. Home Manager links
it to `~/.config/nvim` with `mkOutOfStoreSymlink` (`nix/home/magnus.nix`), so
the link chain ends in the repo:

```
~/.config/nvim -> /nix/store/...-home-manager-files/.config/nvim -> ~/dotfiles/.config/nvim
```

Edits in the repo apply on the next Neovim start without a rebuild. Only
changing the link itself needs `sudo nixos-rebuild switch --flake ~/dotfiles/nix`.

## Files

- `init.lua` - editor options (line numbers, clipboard, cursor), loads the modules below
- `lua/core/ui.lua` - VSCode-like syntax colors and transparent backgrounds
- `lua/core/plugins.lua` - plugins and their setup
- `lua/core/keymaps.lua` - all custom keybinds
- `lua/core/format.lua` - Conform setup and filetype-to-formatter map
- `lua/core/lsp.lua` - enables the language servers
- `lsp/<name>.lua` - one config per language server
- `nvim-pack-lock.json` - pinned plugin revisions

## Plugins

Plugins are installed by Neovim's built-in `vim.pack`; the first start after
adding one asks for confirmation.

- `nvim-treesitter` - syntax highlighting and indentation. Parsers are
  compiled locally with `tree-sitter` and `gcc` from `home.packages`.
- `snacks.nvim` - file explorer and pickers (files, grep, git status,
  diagnostics). Opening a directory (`nvim .`) opens the explorer instead of netrw.
- `gitsigns.nvim` - marks changed lines in the sign column, side-by-side diff
- `which-key.nvim` - popup after `Space` listing the possible next keys
- `conform.nvim` - formats the current buffer with the formatter for its filetype
- `lualine.nvim` - statusline with mode, git branch, diff, diagnostics, file and
  cursor position; needs a Nerd Font for its icons
- `render-markdown.nvim` - renders Markdown in the buffer; `:RenderMarkdown toggle`
  switches back to plain text
- `claudecode.nvim` - Claude Code IDE integration, see below

## Language servers

Enabled in `lua/core/lsp.lua`, one config per server in `lsp/<name>.lua`:

- Go `gopls`, Rust `rust_analyzer`, TypeScript/JavaScript `vtsls`
- Python `pyright` (types) and `ruff` (lint, format)
- Nix `nixd`, Lua `lua_ls`, XML `lemminx` (Odoo views and data)
- JSON `jsonls`, CSS `cssls`, HTML `html`, Svelte `svelte`
- Bash `bashls`, Typst `tinymist`, YAML `yamlls`
- Docker `dockerls` (Compose files go through `yamlls`), QML `qmlls` (Quickshell)
- Ansible `ansiblels`, only for files under `playbooks/` or `roles/*/tasks|handlers/`

The server binaries come from Nix (`nix/home/packages.nix`). Rust's standard
library sources are provided through `RUST_SRC_PATH` in the same module.
Errors show at the end of the line, including in Insert mode, and inlay hints
are on. Rust's full Cargo diagnostics run on save; rust-analyzer also reports
its own live diagnostics on unsaved changes.
The completion menu opens while typing identifiers and on the server's trigger
characters (e.g. `.`); `Ctrl+Y` accepts, `Ctrl+N` / `Ctrl+P` move, `Ctrl+E`
closes. `Ctrl+X Ctrl+O` requests LSP completion manually. `K` shows documentation
in Normal mode; `Ctrl+S` shows signature help in Insert mode.
`:checkhealth vim.lsp` shows which
server attached. Reference configs for other servers: the `lsp/` folder of
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/tree/master/lsp).

## Keybinds

Leader is `Space`; after pressing it, `which-key` shows the possible next keys.

- `Space+e` - toggle the fullscreen file explorer; type to filter, Enter opens
- `Space+c+f` - format the current buffer (Conform, with LSP fallback)
- `Space+f+f` - find files across the git repo (dotfiles included)
- `Space+/` - grep across the git repo
- `Space+g+s` - changed files of the git repo, including untracked ones
  - `Enter` on a submodule - open its git status
  - `Ctrl+G` inside the picker - back up to the parent repo
- `Space+g+d` - toggle side-by-side diff of the current file against git
- `Space+x+x` - all LSP errors and warnings (like "Problems" in VS Code/Zed)
- `]c` / `[c` - next/previous git change

LSP keys are Neovim's defaults (`:h lsp-defaults`): `K` hover, `grn` rename,
`gra` code action, `grr` references, `gd` definition.

## Formatting and checks

`Space+c+f` formats the current buffer. The central `formatters_by_ft` table is
in `lua/core/format.lua`:

- Python: Ruff; Rust: rustfmt; Go: gofmt
- Lua: StyLua; Nix: nixfmt
- JS/TS (including JSX/TSX), JSON/JSONC, HTML, CSS/SCSS/Less, Markdown and YAML
  (including Ansible and Compose): Prettier
- Shell: shfmt; Fish: fish_indent; QML: qmlformat
- Other filetypes, such as XML, Svelte and Typst: attached LSP, if it supports formatting

Formatter executables are provided by `nix/home/packages.nix` and Fish.
After adding packages, run `sudo nixos-rebuild switch --flake ~/dotfiles/nix`.
Conform uses the formatter's project configuration; its Prettier integration
prefers a project-local executable when available. Run `:ConformInfo` to inspect
the selected formatter, executable availability and errors.

Linting and type checking are separate from formatting. The existing language
servers publish diagnostics automatically: for example, Ruff lints Python while
Pyright checks types. `Space+x+x` lists diagnostics; `gra` opens LSP code actions
for fixes. Full-project checks and tests still belong in the project's terminal
commands or CI (for example `ruff check .`, `pyright`, `cargo clippy`,
`cargo test`, or `tsc --noEmit`, depending on the project).

## Claude Code

`claudecode.nvim` speaks the same protocol as the VS Code extension. Neovim
starts a WebSocket server and writes `~/.claude/ide/<port>.lock`; `claude`
finds it there.

1. Start `nvim` and `claude` in the same project folder (any tmux pane or window).
2. Type `/ide` in Claude and pick Neovim, or start with `claude --ide`.
3. Proposed edits open as a diff split in Neovim: `:w` accepts, `:q` rejects.

`cat ~/.claude/ide/*.lock` shows which folder Neovim announced.

## Editor options

- A block cursor in every mode, including Insert (`guicursor = "a:block"`).
- Mouse handling disabled so the terminal handles selection (`mouse = ""`).
- True color rendering enabled (`termguicolors = true`).
- Yank, delete and put through the system clipboard (`clipboard = "unnamedplus"`).
- Absolute line numbers in the gutter (`number = true`).

## Built-in commands

- `:edit path/to/file` opens a file; Tab completes paths.
- `/pattern` searches; `n` and `N` move between matches.
- `Ctrl+F` / `Ctrl+U` move forward a page / back half a page.
- `:ls` lists buffers; `:buffer N` switches to one.
- `:split` and `:vsplit` split the window; `Ctrl+W` moves between windows.
- `Ctrl+N` and `Ctrl+P` complete words in Insert mode on demand.
- `"+y` and `"+p` use the system clipboard when a clipboard provider is available.
- `:help` opens the built-in documentation; `:help lua-guide` covers Lua configuration.
