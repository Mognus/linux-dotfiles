local M = {}

local special_workspaces = {
    { name = "term", command = function(programs) return programs.terminal end },
    { name = "firefox", command = function(programs) return programs.browser end },
    { name = "discord", command = "discord" },
    { name = "notes", command = "obsidian" },
    { name = "files", command = "thunar" },
    { name = "music", command = "chromium --app=https://music.youtube.com" },
}

function M.setup(programs)
    for _, workspace in ipairs(special_workspaces) do
        local command = workspace.command

        if type(command) == "function" then
            command = command(programs)
        end

        hl.workspace_rule({
            workspace = "special:" .. workspace.name,
            on_created_empty = command,
            gaps_out = 24,
        })

        hl.window_rule({
            match = { workspace = "special:" .. workspace.name },
            border_size = 2,
            border_color = "rgb(888888)",
        })
    end
end

return M
