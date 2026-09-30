vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/coder/claudecode.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("snacks").setup({
    explorer = { enabled = true },
    picker = {
        sources = {
            explorer = {
                -- Fullscreen overview with the search field on top; typing filters the tree.
                layout = { preset = "vertical", preview = false, fullscreen = true },
                focus = "input",
                -- Close after opening a file, so it works like a quick overlay.
                auto_close = true,
                -- Explorer defaults to exact matching; turn on fuzzy and ignore case always.
                matcher = { fuzzy = true, smartcase = false, ignorecase = true },
                -- Show dotfiles by default; Alt+H / H still toggles them off.
                hidden = true,
            },
        },
    },
})

-- Marks changed lines in the sign column; ]c / [c jump between hunks.
require("gitsigns").setup({
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        vim.keymap.set("n", "]c", function()
            gitsigns.nav_hunk("next")
        end, { buffer = bufnr, desc = "Next git hunk" })

        vim.keymap.set("n", "[c", function()
            gitsigns.nav_hunk("prev")
        end, { buffer = bufnr, desc = "Previous git hunk" })
    end,
})

-- Starts the WebSocket server that `claude` finds via ~/.claude/ide/<port>.lock.
require("claudecode").setup()

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
    "python",
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
        "python",
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
