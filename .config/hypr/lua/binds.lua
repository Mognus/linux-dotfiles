local M = {}
local mod = "SUPER"

local function mod_bind(keys, dispatcher, opts)
	hl.bind(mod .. " + " .. keys, dispatcher, opts)
end

local function exec(command)
	return hl.dsp.exec_cmd(command)
end

local function toggle_special(name)
	return hl.dsp.workspace.toggle_special(name)
end

function M.setup(programs)
	-- Press Super+A, release it, then choose an action.
	mod_bind("A", hl.dsp.submap("leader"))
	hl.define_submap("leader", function()
		local function leader_bind(key, dispatcher)
			hl.bind(key, function()
				hl.dispatch(hl.dsp.submap("reset"))
				hl.dispatch(dispatcher)
			end)
		end

		leader_bind("Space", exec("qs -p $HOME/.config/quickshell ipc call launcher toggle"))
		leader_bind("W", exec("qs -p $HOME/.config/quickshell ipc call windowswitcher toggle"))
		leader_bind("G", exec("qs -p $HOME/.config/quickshell ipc call settings toggle"))
		leader_bind("V", exec("qs -p $HOME/.config/quickshell ipc call clipboard toggle"))
		leader_bind("T", exec("qs -p $HOME/.config/quickshell ipc call tux toggle"))
		leader_bind("S", exec([[grim -g "$(slurp)" -t png - | wl-copy --type image/png]]))
		leader_bind("SHIFT + V", exec(os.getenv("HOME") .. "/.config/hypr/scripts/record-toggle.sh"))
		leader_bind("P", exec("qs -p $HOME/.config/quickshell ipc call bottombar toggle"))

		for _, program in pairs(programs) do
			if program.workspace and program.key then
				leader_bind(program.key, toggle_special(program.workspace))
			end
		end

		hl.bind("escape", hl.dsp.submap("reset"))
		hl.bind("catchall", hl.dsp.submap("reset"))
	end)

	mod_bind("SHIFT + Return", exec(programs.terminal.command))
	mod_bind("Escape", exec(programs.lock.command))
	mod_bind("F1", exec("systemctl suspend"))

	mod_bind("S", exec([[grim -g "$(slurp)" ~/Pictures/screenshots/$(date +%F_%T).png]]))

	-- Audio keeps working on the lock screen; the Quickshell bar shows the level.
	local volume_up = exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")
	local volume_down = exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
	local volume_mute = exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
	mod_bind("equal", volume_up, { repeating = true, locked = true })
	mod_bind("minus", volume_down, { repeating = true, locked = true })
	mod_bind("0", volume_mute, { locked = true })
	hl.bind("XF86AudioRaiseVolume", volume_up, { repeating = true, locked = true })
	hl.bind("XF86AudioLowerVolume", volume_down, { repeating = true, locked = true })
	hl.bind("XF86AudioMute", volume_mute, { locked = true })
	hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
	hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
	hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
	hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
	hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
	hl.bind("XF86MonBrightnessUp", exec("brightnessctl set 5%+"), { repeating = true, locked = true })
	hl.bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { repeating = true, locked = true })

	mod_bind("Q", hl.dsp.window.close())
	mod_bind("F", hl.dsp.window.fullscreen())
	mod_bind("SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

	-- dwm: j/k walk the master stack, h/l move the master split (mfact).
	mod_bind("j", hl.dsp.layout("cyclenext"))
	mod_bind("k", hl.dsp.layout("cycleprev"))
	mod_bind("SHIFT + j", hl.dsp.layout("swapnext"))
	mod_bind("SHIFT + k", hl.dsp.layout("swapprev"))

	mod_bind("h", hl.dsp.layout("mfact -0.05"), { repeating = true })
	mod_bind("l", hl.dsp.layout("mfact +0.05"), { repeating = true })

	-- dwm zoom: promote the focused window to master.
	mod_bind("Return", hl.dsp.layout("swapwithmaster auto"))

	-- dwm tags: Tab jumps to the last tag, digits pick a tag directly.
	mod_bind("Tab", hl.dsp.focus({ workspace = "previous" }))
	mod_bind("N", hl.dsp.focus({ workspace = "r+1" }))
	mod_bind("P", hl.dsp.focus({ workspace = "r-1" }))

	mod_bind("ALT + bracketleft", hl.dsp.window.move({ workspace = "r-1" }))
	mod_bind("ALT + bracketright", hl.dsp.window.move({ workspace = "r+1" }))

	for i = 1, 9 do
		local key = tostring(i)

		mod_bind(key, hl.dsp.focus({ workspace = i }))
		mod_bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	end
end

return M
