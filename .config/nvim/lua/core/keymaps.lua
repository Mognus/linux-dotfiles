vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

vim.keymap.set("n", "<C-p>", function()
    Snacks.picker.files({
        hidden = true,
        exclude = { ".git" },
    })
end, { desc = "Find files" })

vim.keymap.set("n", "<C-S-f>", function()
    Snacks.picker.grep()
end, { desc = "Grep files" })

vim.keymap.set("n", "<C-S-m>", function()
    Snacks.picker.diagnostics()
end, { desc = "Show problems" })
