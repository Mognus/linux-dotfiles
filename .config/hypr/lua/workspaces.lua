local M = {}

function M.setup(programs)
	for _, program in pairs(programs) do
		if program.workspace then
			hl.workspace_rule({
				workspace = "special:" .. program.workspace,
				on_created_empty = program.command,
				gaps_out = 24,
			})

			hl.window_rule({
				match = { workspace = "special:" .. program.workspace },
				border_size = 2,
				border_color = "rgb(888888)",
			})
		end
	end
end

return M
