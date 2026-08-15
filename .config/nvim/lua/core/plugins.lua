vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/stevearc/conform.nvim" },
})

-- Picker only. File tree lives in Zed now.
require("snacks").setup({
    picker = {
        enabled = true,
        matcher = {
            fuzzy = true,
            smartcase = true,
            ignorecase = true,
            filename_bonus = true,
        },
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
    signature = {
        enabled = true,
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
        map("<A-e>", gs.preview_hunk, "Preview Git hunk")

        -- Aliases matching Zed's vim mode, so both editors share one idiom.
        map("]c", function()
            gs.nav_hunk("next")
        end, "Next Git hunk")
        map("[c", function()
            gs.nav_hunk("prev")
        end, "Previous Git hunk")
    end,
})

local treesitter_languages = {
    "css",
    "go",
    "gomod",
    "html",
    "html_tags",
    "javascript",
    "rust",
    "markdown",
    "markdown_inline",
    "sql",
    "svelte",
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
        "svelte",
        "typescript",
        "typescriptreact",
    },
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
