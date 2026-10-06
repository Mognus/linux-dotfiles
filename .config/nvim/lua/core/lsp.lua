-- Server configs live in lsp/<name>.lua; Neovim picks them up by name.
vim.lsp.enable({
    "gopls",
    "rust_analyzer",
    "ts_ls",
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

-- Completion menu pops up on the server's trigger characters (e.g. "." in
-- Python), like in Zed. Ctrl+Y accepts, Ctrl+N / Ctrl+P move, Ctrl+E closes.
-- Example: "os." → menu with "path", "environ", ...; Ctrl+Y inserts "path".
-- noselect: nothing is preselected, so typing on never inserts an item by accident.
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

-- Show errors at the end of the line, like diagnostics.inline in Zed.
vim.diagnostic.config({ virtual_text = true })

vim.lsp.inlay_hint.enable(true)