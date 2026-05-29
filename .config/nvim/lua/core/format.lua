require("conform").setup({
    formatters_by_ft = {
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        rust            = { "rustfmt" },
    },
})

vim.keymap.set("n", "<C-S-i>", function()
    require("conform").format({ async = true })
end, { desc = "Format file" })
