local git = require("core.git")
local harpoon = require("harpoon")
local harpoon_marks = require("core.harpoon_marks")

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

-- Global because quickfix has its own buffer.
vim.keymap.set("n", "<leader>dc", vim.cmd.cclose, { desc = "Close quickfix" })

vim.keymap.set("n", "<leader>ha", function()
    harpoon:list():add()
end, { desc = "Harpoon add file" })

vim.keymap.set("n", "<leader>hm", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

vim.keymap.set("n", "<leader>ht", harpoon_marks.toggle, { desc = "Toggle Harpoon marks" })

vim.keymap.set("n", "<C-n>", function()
    harpoon:list():next()
end, { desc = "Harpoon next file" })

vim.keymap.set("n", "<C-p>", function()
    harpoon:list():prev()
end, { desc = "Harpoon previous file" })

for index = 1, 4 do
    vim.keymap.set("n", "<leader>h" .. index, function()
        harpoon:list():select(index)
    end, { desc = "Harpoon file " .. index })
end

vim.keymap.set("n", "<leader>gs", git.open_workspace_status, { desc = "Git workspace status" })

vim.keymap.set("n", "<leader>go", function()
    MiniDiff.toggle_overlay()
end, { desc = "Toggle Git diff overlay" })
