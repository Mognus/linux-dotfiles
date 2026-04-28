# Neovim Setup

Neovim is managed from `~/dotfiles/.config/nvim`.

## Does

- Loads config from `init.lua`
- Keeps core behavior in `lua/core`
- Uses `vim.pack` for plugins
- Uses system-installed LSP servers

## Keybinds

| Keybind | Does |
|---|---|
| `Space e` | File explorer |
| `Space f f` | Find files |
| `Space f g` | Grep |
| `Space h a` | Pin current file with Harpoon |
| `Space h m` | Open Harpoon menu |
| `Space h t` | Toggle Harpoon marks overlay |
| `Ctrl n` | Next Harpoon file |
| `Ctrl p` | Previous Harpoon file |
| `Space h 1` - `Space h 4` | Jump to Harpoon file 1-4 |
| `Space g s` | Git workspace status |
| `Space g o` | Toggle diff overlay |
| `Space g d` | Go to definition |
| `Space g r` | References |
| `Space g i` | Hover docs |
| `Space r n` | Rename |
| `Space c a` | Code action |
| `Space d e` | Show diagnostic under cursor |
| `Space d n` | Next diagnostic |
| `Space d p` | Previous diagnostic |
| `Space d q` | Open diagnostics quickfix list |
| `Space d c` | Close quickfix list |

## Workflow

Open files through Oil or picker, pin important files with Harpoon, navigate code through LSP, and use the Git popup for quick changed-file jumps.

## Buffers

A buffer is a loaded file in Neovim memory. A window is only a view onto a buffer, so multiple windows can show the same buffer or different buffers.

Opening one file loads that file as a buffer. Referenced or imported files are not automatically opened as buffers, but the LSP can still know about them through the project root. Jumping to a definition in another file loads that target file as a new buffer.

Useful commands:

| Command | Does |
|---|---|
| `:ls` | List open buffers |
| `:buffers` | List open buffers |
| `:copen` | Open quickfix list |
| `:cclose` | Close quickfix list |
