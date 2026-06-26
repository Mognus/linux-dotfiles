local M = {}

function M.setup(programs)
    hl.on("hyprland.start", function()
        hl.exec_cmd("pactl set-default-source alsa_input.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo")
        hl.exec_cmd("dunst")
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("qs -p " .. os.getenv("HOME") .. "/dotfiles/.config/quickshell")
        hl.exec_cmd(programs.terminal, { workspace = "special:term silent" })
    end)
end

return M
