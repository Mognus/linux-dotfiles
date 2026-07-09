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
    mod_bind("CTRL + P", exec("qs -p $HOME/dotfiles/.config/quickshell ipc call bar toggle"))
    mod_bind("CTRL + T", exec("qs -p $HOME/dotfiles/.config/quickshell ipc call tux toggle"))
    mod_bind("CTRL + G", exec("qs -p $HOME/dotfiles/.config/quickshell ipc call quicksettings toggle"))
    mod_bind("Return", exec(programs.terminal))
    mod_bind("B", exec(programs.browser))
    mod_bind("Space", exec(programs.launcher))
    mod_bind("Escape", exec(programs.lock))
    mod_bind("F1", exec("systemctl suspend"))

    mod_bind("CTRL + B", toggle_special("firefox"))
    mod_bind("CTRL + D", toggle_special("discord"))
    mod_bind("CTRL + N", toggle_special("notes"))
    mod_bind("CTRL + F", toggle_special("files"))
    mod_bind("CTRL + Return", toggle_special("term"))

    mod_bind("CTRL + M", hl.dsp.submap("music"))
    hl.define_submap("music", function()
        bind("M", toggle_special("music"))
        bind("L", toggle_special("cmus"))
        bind("escape", hl.dsp.submap("reset"))
        bind("catchall", hl.dsp.submap("reset"))
    end)

    mod_bind("S", exec([[grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%F_%T).png]]))
    mod_bind("CTRL + S", exec([[grim -g "$(slurp)" -t png - | wl-copy --type image/png]]))
    mod_bind("CTRL + v", exec(os.getenv("HOME") .. "/.config/hypr/scripts/record-toggle.sh"))
    mod_bind("W", exec(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper-switcher.sh"))

    mod_bind("equal", exec(os.getenv("HOME") .. "/.config/hypr/scripts/opacity-switch.sh up"), { repeating = true })
    mod_bind("minus", exec(os.getenv("HOME") .. "/.config/hypr/scripts/opacity-switch.sh down"), { repeating = true })

    mod_bind("Q", hl.dsp.window.close())
    mod_bind("F", hl.dsp.window.fullscreen())
    mod_bind("CTRL + Space", hl.dsp.window.float({ action = "toggle" }))

    mod_bind("h", hl.dsp.focus({ direction = "left" }))
    mod_bind("l", hl.dsp.focus({ direction = "right" }))
    mod_bind("k", hl.dsp.focus({ direction = "up" }))
    mod_bind("j", hl.dsp.focus({ direction = "down" }))

    mod_bind("CTRL + j", hl.dsp.focus({ workspace = "r-1" }))
    mod_bind("CTRL + k", hl.dsp.focus({ workspace = "r+1" }))

    mod_bind("CTRL + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
    mod_bind("CTRL + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
    mod_bind("CTRL + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
    mod_bind("CTRL + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

    mod_bind("ALT + bracketleft", hl.dsp.window.move({ workspace = "r-1" }))
    mod_bind("ALT + bracketright", hl.dsp.window.move({ workspace = "r+1" }))

    mod_bind("SHIFT + h", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
    mod_bind("SHIFT + l", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
    mod_bind("SHIFT + k", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
    mod_bind("SHIFT + j", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

    for i = 1, 9 do
        local key = tostring(i)

        mod_bind(key, hl.dsp.focus({ workspace = i }))
        mod_bind("CTRL + " .. key, hl.dsp.focus({ workspace = i }))
        mod_bind("CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
end

return M
