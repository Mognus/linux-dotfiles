-- Server configs live in lsp/<name>.lua; Neovim picks them up by name.
vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.enable({
    "gopls",
    "rust_analyzer",
    "vtsls",
    "eslint",
    "pyright",
    "ruff",
    "nixd",
    "lua_ls",
    "lemminx",
    "jsonls",
    "cssls",
    "html",
    "bashls",
    "tinymist",
    "yamlls",
    "ansiblels",
    "svelte",
    "dockerls",
    "qmlls",
})

-- Neovim can't tell Ansible YAML from plain YAML, so mark playbooks and role
-- files by path; ansiblels only attaches to "yaml.ansible".
-- Example: "infra/roles/web/tasks/main.yml" → yaml.ansible, "docker-compose.yml" → yaml.
-- Compose files need nothing extra: yamlls picks the Compose schema from
-- SchemaStore by file name.
vim.filetype.add({
    pattern = {
        [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
        [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
        [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    },
})

-- Blink owns completion; do not also enable vim.lsp.completion autotrigger.

-- Show errors at the end of the line, like diagnostics.inline in Zed.
vim.diagnostic.config({ virtual_text = true, update_in_insert = true })

vim.lsp.inlay_hint.enable(true)
