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
            blur = { enabled = false },
        },
        animations = { enabled = false },
        dwindle = {
            preserve_split = true,
        },
    })
end

return M
