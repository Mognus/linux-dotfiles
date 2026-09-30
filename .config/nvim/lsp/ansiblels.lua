-- Only attaches to filetype "yaml.ansible", which lsp.lua sets for playbooks and roles.
return {
    cmd = { "ansible-language-server", "--stdio" },
    filetypes = { "yaml.ansible" },
    root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
}
