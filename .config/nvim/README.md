# Neovim Setup

Neovim is managed from `~/dotfiles/.config/nvim`.

## Does

- Loads config from `init.lua`
- Keeps core behavior in `lua/core`
- Uses `vim.pack` for focused plugins
- Provides a VSCode-like file explorer with Git status
- Provides VSCode-like file search and global grep
- Enables the TypeScript language server for JavaScript and TypeScript projects

## Keybinds

- `Ctrl+B` - Toggle file explorer
- `Ctrl+P` - Find files
- `Ctrl+Shift+F` - Grep files
- `Ctrl+Shift+M` - Show problems
- `F12` - Go to definition
- `Shift+F12` - Find references
- `F24` - Find references fallback for terminals that encode `Shift+F12` as `F24`
- `F2` - Rename symbol
- `Ctrl+.` - Code action
- `K` - Show hover
- `F4` - Show problem under cursor
- `F8` - Next problem
- `Shift+F8` - Previous problem
- `F20` - Previous problem fallback for terminals that encode `Shift+F8` as `F20`

## Workflow

Use the left file explorer for project navigation, then add editor features in small steps from `lua/core`.

## Buffers

A buffer is a loaded file in Neovim memory. A window is only a view onto a buffer, so multiple windows can show the same buffer or different buffers.

Opening one file loads that file as a buffer. Referenced or imported files are not automatically opened as buffers, but the LSP can still know about them through the project root. Jumping to a definition in another file loads that target file as a new buffer.

Useful commands:

- `:ls` - List open buffers
- `:buffers` - List open buffers
- `:copen` - Open quickfix list
- `:cclose` - Close quickfix list
