-- globPattern without "**/" so opening ~/foo.sh doesn't scan the whole home dir.
return {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" },
    settings = {
        bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" },
    },
}
