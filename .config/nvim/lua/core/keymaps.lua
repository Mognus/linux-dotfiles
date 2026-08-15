vim.keymap.set("n", "<C-f>", function()
    Snacks.picker.grep()
end, { desc = "Grep files" })

vim.keymap.set("n", "<C-p>", function()
    Snacks.picker.files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>?", function()
    Snacks.picker.keymaps()
end, { desc = "Show keymaps" })

vim.keymap.set("n", "<leader>d", function()
    Snacks.picker.diagnostics()
end, { desc = "Show problems" })

vim.keymap.set("n", "<leader>s", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Show file symbols" })

vim.keymap.set("n", "<leader>g", function()
    Snacks.picker.git_diff()
end, { desc = "Show Git diff" })

vim.keymap.set("n", "<leader>i", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
