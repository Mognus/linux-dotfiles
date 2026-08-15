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

vim.lsp.config("svelte", {
    cmd = { "svelteserver", "--stdio" },
    filetypes = { "svelte" },
    root_markers = {
        "svelte.config.js",
        "svelte.config.ts",
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
        nodePath = vim.NIL,
        onIgnoredFiles = "off",
        problems = {
            shortenToSingleLine = false,
        },
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
    },
})

vim.lsp.config("tailwindcss", {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_markers = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "package.json",
        ".git",
    },
    settings = {
        tailwindCSS = {
            classAttributes = {
                "class",
                "className",
                "class:list",
                "classList",
                "ngClass",
            },
            classFunctions = {
                "cn",
                "cva",
            },
            validate = true,
        },
    },
})

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = {
        "go",
        "gomod",
        "gowork",
        "gotmpl",
    },
    root_markers = {
        "go.work",
        "go.mod",
        ".git",
    },
})

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = {
        "Cargo.toml",
        "rust-project.json",
        ".git",
    },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            check = {
                command = "clippy",
            },
        },
    },
})

vim.lsp.enable({ "ts_ls", "svelte", "eslint", "tailwindcss", "gopls", "rust_analyzer" })

vim.lsp.inlay_hint.enable(true)

vim.api.nvim_create_user_command("LspRestart", function()
    vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = 0 }))
    vim.cmd("e")
end, {})

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

        -- Everything else (grr, grn, gra, ]d, [d, <C-w>d) is built into 0.12.
        map("gd", function()
            Snacks.picker.lsp_definitions()
        end, "Go to definition")
        map("K", vim.lsp.buf.hover, "Show hover")
    end,
})
