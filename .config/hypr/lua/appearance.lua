local M = {}

local function animations()
    hl.curve("easeOut", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
    hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })

    hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "easeOut", style = "slide" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "linear", style = "slide" })
    hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "linear" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOut", style = "slide" })
    hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "easeOut", style = "slidevert" })
end

function M.setup()
    hl.config({
        general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 0,
            layout = "dwindle",
        },
        decoration = {
            rounding = 0,
            dim_special = 0.4,
            blur = {
                enabled = true,
                size = 4,
                passes = 1,
                noise = 0.1,
            },
        },
        animations = {
            enabled = true,
        },
        dwindle = {
            preserve_split = true,
        },
    })

    animations()
end

return M
