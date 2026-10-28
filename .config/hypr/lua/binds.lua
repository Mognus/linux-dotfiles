local M = {}
local mod = "SUPER"

local function bind(keys, dispatcher, opts)
	hl.bind(keys, dispatcher, opts)
end

local function mod_bind(keys, dispatcher, opts)
	bind(mod .. " + " .. keys, dispatcher, opts)
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
			bind(key, function()
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
		bind("P", hl.dsp.submap("panels"))

		leader_bind("Return", toggle_special("alacritty"))
		leader_bind("B", toggle_special("librewolf"))
		leader_bind("D", toggle_special("discord"))
		leader_bind("C", toggle_special("chat"))
		leader_bind("N", toggle_special("notes"))
		leader_bind("F", toggle_special("files"))
		leader_bind("M", toggle_special("music"))
		leader_bind("R", toggle_special("reader"))

		bind("escape", hl.dsp.submap("reset"))
		bind("catchall", function()
			-- Lua catchall callbacks can also run after a matching keybind.
			-- Keep an explicit switch to the panels submap intact.
			if hl.get_current_submap() == "leader" then
				hl.dispatch(hl.dsp.submap("reset"))
			end
		end)
	end)

	hl.define_submap("panels", function()
		bind("B", function()
			hl.dispatch(exec("qs -p $HOME/.config/quickshell ipc call bottombar toggle"))
			hl.dispatch(hl.dsp.submap("reset"))
		end)
		bind("P", function()
			hl.dispatch(exec("qs -p $HOME/.config/quickshell ipc call workspacehud toggle"))
			hl.dispatch(hl.dsp.submap("reset"))
		end)
		bind("escape", hl.dsp.submap("reset"))
		bind("catchall", hl.dsp.submap("reset"))
	end)

	mod_bind("SHIFT + Return", exec(programs.terminal))
	mod_bind("Escape", exec(programs.lock))
	mod_bind("F1", exec("systemctl suspend"))

	mod_bind("S", exec([[grim -g "$(slurp)" ~/Pictures/screenshots/$(date +%F_%T).png]]))

	-- Audio keeps working on the lock screen; the Quickshell bar shows the level.
	local volume_up = exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")
	local volume_down = exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
	local volume_mute = exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
	mod_bind("equal", volume_up, { repeating = true, locked = true })
	mod_bind("minus", volume_down, { repeating = true, locked = true })
	mod_bind("0", volume_mute, { locked = true })
	bind("XF86AudioRaiseVolume", volume_up, { repeating = true, locked = true })
	bind("XF86AudioLowerVolume", volume_down, { repeating = true, locked = true })
	bind("XF86AudioMute", volume_mute, { locked = true })
	bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
	bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
	bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
	bind("XF86AudioNext", exec("playerctl next"), { locked = true })
	bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
	bind("XF86MonBrightnessUp", exec("brightnessctl set 5%+"), { repeating = true, locked = true })
	bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { repeating = true, locked = true })

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
