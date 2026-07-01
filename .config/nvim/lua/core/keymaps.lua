local git = require("core.git")

vim.keymap.set("n", "<C-b>", function()
    Snacks.explorer()
end, { desc = "Toggle file explorer" })

vim.keymap.set("n", "<C-f>", function()
    Snacks.picker.grep()
end, { desc = "Grep files" })

vim.keymap.set("n", "<C-p>", function()
    Snacks.picker.files()
end, { desc = "Find files" })

vim.keymap.set("n", "<C-t>", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<C-q>", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<C-j>", "<cmd>tabprev<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<C-k>", "<cmd>tabnext<CR>", { desc = "Next tab" })

vim.keymap.set("n", "<F1>", function()
    Snacks.picker.keymaps()
end, { desc = "Show keymaps" })

vim.keymap.set("n", "<F3>", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

vim.keymap.set("n", "<C-S-m>", function()
    Snacks.picker.diagnostics()
end, { desc = "Show problems" })

vim.keymap.set("n", "<C-S-o>", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Show file symbols" })

vim.keymap.set("n", "<A-u>", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@function.outer", "@class.outer" }, "textobjects")
end, { desc = "Previous function or class" })

vim.keymap.set("n", "<A-d>", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@function.outer", "@class.outer" }, "textobjects")
end, { desc = "Next function or class" })

vim.keymap.set("n", "<C-g>", function()
    git.workspace_status()
end, { desc = "Show Git workspace status" })

vim.keymap.set("n", "<A-S-g>", function()
    Snacks.picker.git_diff()
end, { desc = "Show Git diff" })
