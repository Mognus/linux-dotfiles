vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/nanozuki/tabby.nvim" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/kylechui/nvim-surround" },
})

require("snacks").setup({
    explorer = {
        enabled = true,
        replace_netrw = true,
    },
    picker = {
        enabled = true,
        sources = {
            explorer = {
                hidden = true,
                ignored = true,
                git_status = true,
                git_status_open = true,
                git_untracked = true,
                formatters = {
                    file = { git_status_hl = true },
                },
                jump = { close = true },
                win = {
                    list = {
                        keys = { t = "tab" },
                    },
                },
                layout = {
                    preset = "default",
                    preview = false,
                    layout = {
                        width = 0.9,
                        height = 0.9,
                    },
                },
            },
        },
    },
})

require("flash").setup()

vim.keymap.set({ "n", "x", "o" }, "gw", function()
    require("flash").jump()
end, { desc = "Flash jump" })

vim.keymap.set({ "n", "x", "o" }, "gW", function()
    require("flash").treesitter()
end, { desc = "Flash treesitter jump" })

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

require("nvim-autopairs").setup({
    check_ts = true,
})

require("tabby").setup({ preset = "tab_only" })

require("render-markdown").setup()

require("nvim-surround").setup()

require("Comment").setup({ mappings = false })

vim.keymap.set("n", "<C-S-k>", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

vim.keymap.set("x", "<C-S-k>", function()
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment" })

require("todo-comments").setup({
    signs = true,
})

local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        return "no lsp"
    end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end
    return table.concat(names, ",")
end

require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
            {
                "filename",
                path = 1,
                symbols = {
                    modified = " [+]",
                    readonly = " [ro]",
                    unnamed = "[no name]",
                },
            },
        },
        lualine_x = {
            "diagnostics",
            lsp_clients,
            "encoding",
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
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
        map("<A-e>", gs.preview_hunk, "Preview Git hunk")

    end,
})

local treesitter_languages = {
    "go",
    "gomod",
    "javascript",
    "rust",
    "markdown",
    "markdown_inline",
    "sql",
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
