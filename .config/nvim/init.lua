-- Keep stock keybindings; customize appearance and syntax with Lua.

-- Use a block cursor in every mode, including Insert.
vim.opt.guicursor = "a:block"

-- Keep mouse handling in the terminal, like classic Vim.
vim.opt.mouse = ""

vim.opt.termguicolors = true

require("core.ui")
require("core.plugins")
