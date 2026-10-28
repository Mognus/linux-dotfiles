local M = {}

local special_workspaces = {
	{ name = "alacritty", command = "alacritty" },
	{ name = "librewolf", command = "librewolf" },
	{ name = "discord", command = "discord" },
	{ name = "chat", command = "simplex-chat-desktop" },
	{ name = "notes", command = "obsidian" },
	{ name = "files", command = "thunar" },
	{ name = "music", command = "chromium --app=https://music.youtube.com" },
	{ name = "reader", command = "foliate" },
}

function M.setup()
	for _, workspace in ipairs(special_workspaces) do
		local command = workspace.command

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
