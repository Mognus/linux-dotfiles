local M = {}

function M.setup()
    hl.on("hyprland.start", function()
        hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/polkit-agent")
        hl.exec_cmd("wl-paste --watch cliphist store")
        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("awww img " .. os.getenv("HOME") .. "/.config/wallpapers/tank-girl-wallpaper-black.png")
    end)
end

return M
