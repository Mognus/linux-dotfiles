vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/coder/claudecode.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    -- Renders Markdown in the buffer; the cursor line stays raw for editing.
    -- `:RenderMarkdown toggle` switches back to plain text.
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("snacks").setup({
    explorer = { enabled = true },
    picker = {
        -- Alt+. (dot = dotfiles) toggles hidden files in every picker while typing in the
        -- search field. The stock Alt+H is swallowed by tmux (select-pane -L).
        win = { input = { keys = { ["<A-.>"] = { "toggle_hidden", mode = { "i", "n" } } } } },
        sources = {
            explorer = {
                -- Fullscreen overview with the search field on top; typing filters the tree.
                layout = { preset = "vertical", preview = false, fullscreen = true },
                focus = "input",
                -- Close after opening a file, so it works like a quick overlay.
                auto_close = true,
                -- Exact substring match, ignoring case. Fuzzy matches letters spread over the
                -- whole path, e.g. "readme" hits "tRaEno_project_ADMin.../ir.ModEl..." too.
                matcher = { fuzzy = false, smartcase = false, ignorecase = true },
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

-- Statusline: mode, git branch, diff, diagnostics, file, cursor position. The stock
-- defaults already cover that, the colors follow the active color scheme (theme = "auto").
require("lualine").setup()

-- Starts the WebSocket server that `claude` finds via ~/.claude/ide/<port>.lock.
require("claudecode").setup()

local treesitter_languages = {
    "css",
    "dockerfile",
    "go",
    "gomod",
    "html",
    "html_tags",
    "javascript",
    "lua",
    "rust",
    "markdown",
    "markdown_inline",
    "python",
    "qmljs",
    "sql",
    "svelte",
    "tsx",
    "typescript",
    "yaml",
}

require("nvim-treesitter").install(treesitter_languages)

-- Neovim names the filetype "qml", but the parser is called "qmljs".
vim.treesitter.language.register("qmljs", "qml")

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "go",
        "gomod",
        "gowork",
        "gotmpl",
        "javascript",
        "javascriptreact",
        "lua",
        "python",
        "rust",
        "svelte",
        "typescript",
        "typescriptreact",
        -- FileType matches the whole name, so "yaml" alone misses "yaml.ansible".
        "yaml",
        "yaml.ansible",
    },
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- nvim-treesitter ships no indent query for Dockerfiles and QML, so only
-- highlight and keep Vim's own indent there.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dockerfile", "qml" },
    callback = function()
        vim.treesitter.start()
    end,
})
