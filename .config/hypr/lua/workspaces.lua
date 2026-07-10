local M = {}

local special_workspaces = {
    { name = "term", command = function(programs) return programs.terminal end, gaps_out = 32 },
    { name = "firefox", command = "firefox", gaps_out = 32 },
    { name = "discord", command = "discord", gaps_out = 32 },
    { name = "notes", command = "obsidian", gaps_out = { top = 32, right = 240, bottom = 32, left = 240 } },
    { name = "files", command = "thunar", gaps_out = 32 },
    { name = "music", command = "chromium --app=https://music.youtube.com", gaps_out = 32 },
    { name = "cmus", command = function(programs) return programs.terminal .. " -e cmus" end, gaps_out = 32 },
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
            gaps_out = workspace.gaps_out,
        })
    end
end

return M
