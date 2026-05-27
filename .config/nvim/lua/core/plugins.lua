vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
})

require("snacks").setup({
    picker = {
        enabled = true,
    },
})

require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Esc>"] = { "hide", "fallback" },
    },
    sources = {
        default = { "lsp", "path", "buffer" },
    },
    completion = {
        menu = {
            auto_show = true,
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 300,
        },
    },
    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },
})

require("nvim-autopairs").setup({
    check_ts = true,
})

require("todo-comments").setup({
    signs = true,
})

require("nvim-treesitter-textobjects").setup({
    move = {
        set_jumps = true,
    },
})

require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "?" },
    },
    on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(keys, action, desc)
            vim.keymap.set("n", keys, action, { buffer = bufnr, desc = desc })
        end

        map("<A-n>", function()
            gs.nav_hunk("next")
        end, "Next Git hunk")
        map("<A-p>", function()
            gs.nav_hunk("prev")
        end, "Previous Git hunk")
        map("<A-h>", gs.preview_hunk, "Preview Git hunk")
        map("<A-s>", gs.stage_hunk, "Stage Git hunk")
        map("<A-r>", gs.reset_hunk, "Reset Git hunk")
    end,
})

local treesitter_languages = {
    "go",
    "gomod",
    "javascript",
    "rust",
    "tsx",
    "typescript",
}

require("nvim-treesitter").install(treesitter_languages)

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "go",
        "gomod",
        "gowork",
        "gotmpl",
        "javascript",
        "javascriptreact",
        "rust",
        "typescript",
        "typescriptreact",
    },
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
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
