local git = require("core.git")

vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

vim.keymap.set("n", "<F1>", function()
    Snacks.picker.keymaps()
end, { desc = "Show keymaps" })

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

vim.keymap.set("n", "<C-S-g>", function()
    git.workspace_status()
end, { desc = "Show Git workspace status" })

vim.keymap.set("n", "<A-S-g>", function()
    Snacks.picker.git_diff()
end, { desc = "Show Git diff" })
