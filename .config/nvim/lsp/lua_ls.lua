-- Neovim runs Lua 5.1 via LuaJIT; the runtime path makes `vim.*` known,
-- otherwise every `vim.` in this config shows "undefined global".
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { library = { vim.env.VIMRUNTIME } },
        },
    },
}
