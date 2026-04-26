vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/malewicz1337/oil-git.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
    { src = "https://github.com/nvim-mini/mini.diff" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

require("oil").setup({
    default_file_explorer = false,
    view_options = {
        show_hidden = true,
    },
})

require("oil-git").setup({
    show_file_highlights = true,
    show_directory_highlights = true,
    show_file_symbols = true,
    show_directory_symbols = true,
})

require("snacks").setup({
    picker = {
        enabled = true,
    },
})

require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 300,
        },
    },
    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },
})

require("mini.diff").setup({
    view = {
        style = "sign",
        signs = { add = "+", change = "~", delete = "-" },
    },
})

require("lualine").setup()
