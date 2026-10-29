local M = {}

function M.setup()
    hl.config({
        general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 0,
            layout = "master",
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
        master = {
            mfact = 0.55,
            orientation = "left",
            new_status = "slave",
        },
    })

    hl.layer_rule({
        match = { namespace = "^settings$" },
        blur = true,
        xray = false,
    })
end

return M
