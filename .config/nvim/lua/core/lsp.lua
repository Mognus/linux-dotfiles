-- Server configs live in lsp/<name>.lua; Neovim picks them up by name.
vim.lsp.enable({
    "gopls",
    "rust_analyzer",
    "ts_ls",
    "pyright",
    "ruff",
})

-- Show errors at the end of the line, like diagnostics.inline in Zed.
vim.diagnostic.config({ virtual_text = true })

vim.lsp.inlay_hint.enable(true)