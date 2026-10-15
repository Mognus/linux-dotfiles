-- Conform reads the current buffer's filetype and uses the matching formatter.
-- Example: a Python buffer → ruff_format → `ruff format` on the buffer contents.
require("conform").setup({
    formatters_by_ft = {
        python = { "ruff_format" },
        rust = { "rustfmt" },
        go = { "gofmt" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        ["yaml.ansible"] = { "prettier" },
        ["yaml.docker-compose"] = { "prettier" },
        ["yaml.gitlab"] = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        fish = { "fish_indent" },
        qml = { "qmlformat" },
    },
    -- Other filetypes (e.g. XML, Svelte, Typst) use their attached language server.
    default_format_opts = {
        lsp_format = "fallback",
    },
})
