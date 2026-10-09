-- Native Hyprland Lua config.
hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE", "40")

-- When the lock screen crashes the session stays locked; this lets a new one take
-- over, e.g. from a TTY: WAYLAND_DISPLAY=wayland-1 qs -p ~/.config/quickshell/lock.qml
hl.config({ misc = { allow_session_lock_restore = true } })

local programs = require("lua.programs")

require("lua.monitors")
require("lua.autostart").setup(programs)
require("lua.input")
require("lua.appearance").setup()
require("lua.workspaces").setup(programs)
require("lua.binds").setup(programs)
