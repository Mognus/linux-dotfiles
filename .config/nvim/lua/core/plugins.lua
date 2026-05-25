vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
    picker = {
        enabled = true,
    },
})

-- VSCode-like Git colors for the file explorer.
vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = "#e2c08d" })
vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = "#73c991" })
vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = "#73c991" })
vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = "#f14c4c" })
vim.api.nvim_set_hl(0, "NvimTreeGitRenamed", { fg = "#73c991" })
vim.api.nvim_set_hl(0, "NvimTreeGitMerge", { fg = "#c586c0" })
vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { fg = "#8c8c8c" })

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 34,
        side = "left",
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                git = {
                    unstaged = "M",
                    staged = "S",
                    unmerged = "U",
                    renamed = "R",
                    untracked = "?",
                    deleted = "D",
                    ignored = "I",
                },
            },
        },
    },
    git = {
        enable = true,
        ignore = false,
    },
    filters = {
        dotfiles = false,
    },
})
