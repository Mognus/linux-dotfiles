local M = {}

function M.setup()
	-- Floating windows may take focus themselves. Without this the keyboard stays
	-- in the calling app and dialogs have to be clicked before typing.
	hl.config({
		misc = {
			focus_on_activate = true,
		},
	})

	-- Floating windows open centred instead of wherever the client drops them.
	hl.window_rule({
		match = { float = true },
		center = true,
	})

	-- GTK file dialogs ask for more height than the screen has. Without a fixed
	-- size Hyprland clamps them and the file name field ends up off screen.
	hl.window_rule({
		match = { class = "xdg-desktop-portal-gtk" },
		size = "1100 900",
	})
end

return M
