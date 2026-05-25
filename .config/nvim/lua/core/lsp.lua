vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_markers = {
        "tsconfig.json",
        "jsconfig.json",
        "package.json",
        ".git",
    },
})

vim.lsp.config("eslint", {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_markers = {
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        "package.json",
        ".git",
    },
    settings = {
        validate = "on",
        packageManager = "pnpm",
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

vim.lsp.enable({ "ts_ls", "eslint" })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local function map(keys, action, desc)
            vim.keymap.set("n", keys, action, { buffer = args.buf, desc = desc })
        end

        map("<F12>", function()
            Snacks.picker.lsp_definitions()
        end, "Go to definition")
        map("<S-F12>", function()
            Snacks.picker.lsp_references()
        end, "Find references")
        map("<F24>", function()
            Snacks.picker.lsp_references()
        end, "Find references")
        map("<F2>", vim.lsp.buf.rename, "Rename symbol")
        map("<C-.>", vim.lsp.buf.code_action, "Code action")
        map("K", vim.lsp.buf.hover, "Show hover")
        map("<F4>", vim.diagnostic.open_float, "Show problem")
        map("<F8>", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, "Next problem")
        map("<S-F8>", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous problem")
        map("<F20>", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Previous problem")
    end,
})
