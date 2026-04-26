# Neovim Setup

Minimal Neovim setup managed from `~/dotfiles/.config/nvim`.

## Structure

```text
init.lua
lua/core/options.lua
lua/core/ui.lua
lua/core/plugins.lua
lua/core/lsp.lua
lua/core/git.lua
lua/core/keymaps.lua
```

`init.lua` only loads the core modules. Most changes should go into the matching file under `lua/core`.

## Plugins

Plugins are installed with Neovim's built-in `vim.pack`.

Current plugins:

- `oil.nvim`: floating file explorer
- `oil-git.nvim`: Git status symbols in Oil
- `snacks.nvim`: file, grep, and Git pickers
- `blink.cmp`: completion menu
- `mini.diff`: Git diff signs in buffers
- `lualine.nvim`: statusline

## Keymaps

Leader is `Space`.

```text
Space e    open floating file explorer
Space f f  find files
Space f g  grep files
Space g s  show Git workspace status
Space g d  toggle Git diff overlay
```

LSP keymaps:

```text
gd          go to definition
gr          show references
K           hover docs
Space r n   rename symbol
Space c a   code action
```

Completion:

```text
Tab         accept completion
Ctrl-j      next completion item
Ctrl-k      previous completion item
Ctrl-e      close completion menu
```

## Git Workspace Status

`Space g s` shows changed files grouped by Git repository/submodule.

Inside the popup:

```text
Enter       open selected file
q           close popup
Esc         close popup
```

## LSP

LSP servers are installed as normal system programs, not through Mason.

Configured servers:

```text
ts_ls       TypeScript, React, Next
eslint      ESLint diagnostics and code actions
gopls       Go
buf_ls      Protobuf through Buf
```
