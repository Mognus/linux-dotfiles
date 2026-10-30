local M = {}

function M.setup(programs)
	for _, program in pairs(programs) do
		if program.workspace then
			hl.workspace_rule({
				workspace = "special:" .. program.workspace,
				on_created_empty = program.command,
				gaps_out = {
					top = 0,
					bottom = 0,
					left = 60,
					right = 60,
				},
			})

			hl.window_rule({
				match = { workspace = "special:" .. program.workspace },
				border_size = 0,
			})
		end
	end
end

return M
