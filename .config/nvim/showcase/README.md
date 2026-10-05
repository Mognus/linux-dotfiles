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
- `lualine.nvim` - statusline with mode, git branch, diff, diagnostics, file and
  cursor position; needs a Nerd Font for its icons
- `claudecode.nvim` - Claude Code IDE integration, see below

## Language servers

Enabled in `lua/core/lsp.lua`, one config per server in `lsp/<name>.lua`:

- Go `gopls`, Rust `rust_analyzer`, TypeScript/JavaScript `ts_ls`
- Python `pyright` (types) and `ruff` (lint, format)
- Nix `nixd`, Lua `lua_ls`, XML `lemminx` (Odoo views and data)
- JSON `jsonls`, CSS `cssls`, HTML `html`, Svelte `svelte`
- Bash `bashls`, Typst `tinymist`, YAML `yamlls`
- Ansible `ansiblels`, only for files under `playbooks/` or `roles/*/tasks|handlers/`

The server binaries come from Nix (`nix/home/packages.nix`). Errors show at
the end of the line, inlay hints are on. `:checkhealth vim.lsp` shows which
server attached. Reference configs for other servers: the `lsp/` folder of
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/tree/master/lsp).

## Keybinds

Leader is `Space`.

- `Ctrl+B` - fullscreen file explorer; type to filter the tree, Enter opens
- `Ctrl+P` - find files in the git repo
- `Ctrl+/` - grep in the git repo
- `Ctrl+G` - changed files of the git repo, including new ones
  - `Enter` on a submodule - open the git status of that submodule
  - `Ctrl+G` inside the picker - back up to the parent repo
  - `Tab` - stage, `Ctrl+R` - restore
- `Space+D` - toggle side-by-side diff of the current file against git
- `]c` / `[c` - next/previous git change
- `F8` - all LSP errors and warnings of open buffers

These replace stock keys: `Ctrl+B` (page up, use `Ctrl+U`), `Ctrl+G` (file
info, use `:file`) and `Ctrl+P` in Normal mode (line up, use `k`). The tmux
prefix moved to `Ctrl+Space` so `Ctrl+B` reaches Neovim.

LSP keys are Neovim's defaults: `K` hover, `grn` rename, `gra` code action,
`grr` references, `Ctrl+]` definition.

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

## Built-in commands

- `:edit path/to/file` opens a file; Tab completes paths.
- `/pattern` searches; `n` and `N` move between matches.
- `Ctrl+F` / `Ctrl+U` move forward a page / back half a page.
- `:ls` lists buffers; `:buffer N` switches to one.
- `:split` and `:vsplit` split the window; `Ctrl+W` moves between windows.
- `Ctrl+N` and `Ctrl+P` complete words in Insert mode on demand.
- `"+y` and `"+p` use the system clipboard when a clipboard provider is available.
- `:help` opens the built-in documentation; `:help lua-guide` covers Lua configuration.
