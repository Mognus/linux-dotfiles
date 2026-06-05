-- Native Hyprland Lua config.
local programs = require("lua.programs")

require("lua.monitors")
require("lua.autostart").setup(programs)
require("lua.input")
require("lua.appearance").setup()
require("lua.workspaces").setup(programs)
require("lua.binds").setup(programs)
