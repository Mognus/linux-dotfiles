local M = {}

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
            dim_special = 0.5,
            blur = {
                enabled = true,
                special = true,
                size = 6,
                passes = 1,
                noise = 0.1,
            },
        },
        animations = { enabled = false },
        dwindle = {
            preserve_split = true,
        },
    })
end

return M
