-- pyright checks types; linting and formatting come from ruff (see ruff.lua).
return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py", ".git" },
}
