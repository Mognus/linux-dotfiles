local M = {}

function M.setup(programs)
    hl.on("hyprland.start", function()
        hl.exec_cmd("pactl set-default-source alsa_input.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo")
        hl.exec_cmd("waybar")
        hl.exec_cmd(os.getenv("HOME") .. "/.config/waybar/scripts/scratchpad-listener.sh")
        hl.exec_cmd("dunst")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd([[sleep 2 && hyprctl hyprpaper wallpaper "DP-3,/home/magnus/.config/wallpapers/Tank-Girl-Wallpaper-Black.png"]])
        hl.exec_cmd(programs.terminal, { workspace = "special:term silent" })
        hl.exec_cmd("eww open-many tux-angel tux-devil slideshow")
    end)
end

return M
