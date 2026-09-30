vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/coder/claudecode.nvim" },
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
