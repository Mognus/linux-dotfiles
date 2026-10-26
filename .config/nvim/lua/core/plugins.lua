vim.pack.add({
    { src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
    { src = "https://github.com/nickjvandyke/opencode.nvim", version = "v1.0.2" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
    { src = "https://github.com/dmmulroy/tsc.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/folke/noice.nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    -- Renders Markdown in the buffer; the cursor line stays raw for editing.
    -- `:RenderMarkdown toggle` switches back to plain text.
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("core.format")
require("blink.cmp").setup({
    keymap = { preset = "default" },
    completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    -- No downloaded native binary or build step needed on NixOS.
    fuzzy = { implementation = "lua" },
    cmdline = { enabled = false },
})
require("nvim-ts-autotag").setup()
-- Use explicit Flash mappings; keep native character motions and searches.
require("flash").setup({
    modes = {
        char = { enabled = false },
        search = { enabled = false },
    },
})
require("tsc").setup({
    -- Follow project references as well as checking a single tsconfig.
    flags = "--build --noEmit",
    use_diagnostics = true,
})

-- Connect on demand to OpenCode in tmux; do not create another embedded terminal.
vim.g.opencode_opts = {
    server = {
        start = function()
            vim.notify("Start opencode --port 0 in a tmux pane in this project", vim.log.levels.INFO)
        end,
    },
}

require("snacks").setup({
    input = { enabled = true },
    indent = { enabled = true },
    explorer = { enabled = true },
    picker = {
        sources = {
            explorer = {
                layout = { fullscreen = true },
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

-- Popup after Space (and other prefixes) listing the possible next keys. The entries come
-- from the `desc` of each vim.keymap.set; only the group names are given here.
local which_key = require("which-key")
which_key.setup({
    triggers = {
        { "<auto>", mode = "niotc" },
        -- Keep leader help in Visual mode without opening it on v / V / Ctrl+V.
        { "<leader>", mode = "x" },
    },
})
which_key.add({
    { "<leader>a", group = "OpenCode", mode = { "n", "x" } },
    { "<leader>c", group = "code" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>x", group = "diagnostics" },
})

-- Keep Neovim's partial-command display in the statusline, separate from Noice.
vim.opt.showcmd = true
vim.opt.showcmdloc = "statusline"
-- Keep Lualine's defaults and add the native showcmd placeholder (%S).
require("lualine").setup({
    sections = {
        lualine_x = { "%S", "encoding", "fileformat", "filetype" },
    },
})

-- Popup command/search input and message history (:Noice).
-- Uses the existing Snacks notification backend, with Noice's mini view as fallback.
require("noice").setup({
    cmdline = {
        format = {
            search_down = { icon = "/" },
            search_up = { icon = "?" },
        },
    },
    presets = {
        command_palette = true,
        long_message_to_split = true,
    },
})

-- Noice has no built-in operator prefix for searches; replace only the icon.
-- Check the previous mode: v:operator also retains actions after they finish.
vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("SearchOperator", { clear = true }),
    pattern = "*:c",
    callback = function()
        local direction = vim.fn.getcmdtype()
        if direction ~= "/" and direction ~= "?" then
            return
        end

        -- Noice initializes on VimEnter, after this configuration is loaded.
        local cmdline = require("noice.config").options.cmdline
        if not cmdline then
            return
        end
        local name = direction == "/" and "search_down" or "search_up"
        local format = cmdline.format[name]
        local operator_pending = vim.v.event.old_mode:match("^no") ~= nil
        format.icon = operator_pending and (vim.v.operator .. direction) or direction
    end,
})

local treesitter_languages = {
    "bash",
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
    "regex",
    "sql",
    "svelte",
    "tsx",
    "typescript",
    "vim",
    "yaml",
}

require("nvim-treesitter").install(treesitter_languages)

-- Neovim names the filetype "qml", but the parser is called "qmljs".
vim.treesitter.language.register("qmljs", "qml")

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "css",
        "go",
        "gomod",
        "gowork",
        "gotmpl",
        "html",
        "javascript",
        "javascriptreact",
        "lua",
        "python",
        "rust",
        "sql",
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
