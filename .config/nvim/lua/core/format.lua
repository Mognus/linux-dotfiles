require("conform").setup({
    formatters_by_ft = {
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        rust            = { "rustfmt" },
    },
})

vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ async = true })
end, { desc = "Format file" })
