# Neovim Setup

Configuration lives in `~/dotfiles/.config/nvim/init.lua`, linked to
`~/.config/nvim` by Stow. Edit this Lua file to customize editor options.

The setup keeps Neovim's built-in keybindings. The only external plugin is
`nvim-treesitter`, for syntax highlighting and indentation. Existing syntax
colors and transparent backgrounds remain in `lua/core/ui.lua`; parser setup
lives in `lua/core/plugins.lua`.

There are no configured language servers, automatic completion popups, pickers,
custom keybindings, or formatting integrations.

Editor options:

- A block cursor in every mode, including Insert (`guicursor = "a:block"`).
- Mouse handling disabled so the terminal handles selection (`mouse = ""`).
- True color rendering enabled (`termguicolors = true`).

## Built-in commands

- `:edit path/to/file` opens a file; Tab completes paths.
- `:Explore` browses directories with the bundled netrw plugin.
- `/pattern` searches; `n` and `N` move between matches.
- `Ctrl+F` and `Ctrl+B` move forward and backward by a page.
- `:ls` lists buffers; `:buffer N` switches to one.
- `:split` and `:vsplit` split the window; `Ctrl+W` moves between windows.
- `Ctrl+N` and `Ctrl+P` complete words in Insert mode on demand.
- `"+y` and `"+p` use the system clipboard when a clipboard provider is available.
- `:help` opens the built-in documentation; `:help lua-guide` covers Lua configuration.

Previously downloaded plugins other than `nvim-treesitter` under
`~/.local/share/nvim/site/pack/core/opt` are no longer loaded by this configuration.
