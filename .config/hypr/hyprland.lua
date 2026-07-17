-- Native Hyprland Lua config.
hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE", "40")

local programs = require("lua.programs")

require("lua.monitors")
require("lua.autostart").setup(programs)
require("lua.input")
require("lua.appearance").setup()
require("lua.workspaces").setup(programs)
require("lua.binds").setup(programs)
