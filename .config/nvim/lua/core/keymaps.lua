local git = require("core.git")

vim.keymap.set("n", "<leader>e", function()
    require("oil").toggle_float(vim.fn.expand("%:p:h"))
end, { desc = "Open file explorer" })

vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files({
        hidden = true,
        exclude = { ".git" },
    })
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
    Snacks.picker.grep()
end, { desc = "Grep files" })

vim.keymap.set("n", "<leader>gs", git.open_workspace_status, { desc = "Git workspace status" })

vim.keymap.set("n", "<leader>gd", function()
    MiniDiff.toggle_overlay()
end, { desc = "Toggle Git diff overlay" })
