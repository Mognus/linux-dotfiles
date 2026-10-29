local M = {}

function M.setup()
    hl.on("hyprland.start", function()
        hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/polkit-agent")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("wl-paste --watch cliphist store")
        -- Generate the saved palette before themed desktop processes start.
        hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/appearancectl restore")
        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("awww img " .. os.getenv("HOME") .. "/.config/wallpapers/tank-girl-wallpaper-black.png")
        hl.exec_cmd("qs -p " .. os.getenv("HOME") .. "/.config/quickshell")
    end)
end

return M
