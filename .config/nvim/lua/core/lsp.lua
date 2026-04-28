vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "package.json", ".git" },
})

vim.lsp.config("eslint", {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "package.json", ".git" },
    settings = {
        validate = "on",
        packageManager = "npm",
        useFlatConfig = true,
        workingDirectory = { mode = "auto" },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = "separateLine",
            },
            showDocumentation = {
                enable = true,
            },
        },
        codeActionOnSave = {
            enable = false,
            mode = "all",
        },
        experimental = {
            useFlatConfig = true,
        },
        format = false,
        nodePath = "",
        onIgnoredFiles = "off",
        problems = {
            shortenToSingleLine = false,
        },
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
    },
})

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
})

vim.lsp.config("buf_ls", {
    cmd = { "buf", "lsp", "serve" },
    filetypes = { "proto" },
    root_markers = { "buf.yaml", "buf.work.yaml", ".git" },
})

vim.lsp.enable({ "ts_ls", "eslint", "gopls", "buf_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local function map(keys, action, desc)
            vim.keymap.set("n", keys, action, { buffer = args.buf, desc = desc })
        end

        map("<leader>gd", vim.lsp.buf.definition, "Go to definition")
        map("<leader>gr", vim.lsp.buf.references, "Go to references")
        map("<leader>gi", vim.lsp.buf.hover, "Show symbol info")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>de", vim.diagnostic.open_float, "Show diagnostic")
        map("<leader>dn", vim.diagnostic.goto_next, "Next diagnostic")
        map("<leader>dp", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("<leader>dq", vim.diagnostic.setqflist, "Diagnostics quickfix")
    end,
})
