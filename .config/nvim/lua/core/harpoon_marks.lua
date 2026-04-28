local M = {}

local state = {
    bufnr = nil,
    winid = nil,
    visible = false,
}

local function is_open()
    return state.winid and vim.api.nvim_win_is_valid(state.winid)
end

local function current_file()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return ""
    end

    return vim.fn.fnamemodify(name, ":.")
end

local function short_name(path)
    local name = vim.fn.fnamemodify(path, ":t")

    if name == "" then
        return path
    end

    return name
end

local function build_lines()
    local harpoon = require("harpoon")
    local list = harpoon:list()
    local active = current_file()
    local lines = {}

    for index = 1, list:length() do
        local item = list:get(index)

        if item then
            local prefix = item.value == active and "> " or "  "
            lines[#lines + 1] = prefix .. index .. " " .. short_name(item.value)
        end
    end

    if #lines == 0 then
        lines[1] = "No marks"
    end

    return lines
end

local function content_width(lines)
    local width = 10

    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end

    return math.min(width, 32)
end

local function ensure_buffer()
    if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
        return
    end

    state.bufnr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_set_option_value("buftype", "nofile", { buf = state.bufnr })
    vim.api.nvim_set_option_value("bufhidden", "hide", { buf = state.bufnr })
    vim.api.nvim_set_option_value("swapfile", false, { buf = state.bufnr })
end

local function set_lines(lines)
    vim.api.nvim_set_option_value("modifiable", true, { buf = state.bufnr })
    vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = state.bufnr })
end

local function window_options(lines)
    local width = content_width(lines)

    return {
        relative = "editor",
        row = 1,
        col = math.max(0, vim.o.columns - width - 2),
        width = width,
        height = #lines,
        anchor = "NW",
        focusable = false,
        style = "minimal",
        border = "single",
        title = " Harpoon ",
        title_pos = "center",
        zindex = 40,
    }
end

function M.refresh()
    if not state.visible then
        return
    end

    ensure_buffer()

    local lines = build_lines()
    set_lines(lines)

    if is_open() then
        vim.api.nvim_win_set_config(state.winid, window_options(lines))
        return
    end

    state.winid = vim.api.nvim_open_win(state.bufnr, false, window_options(lines))
end

function M.close()
    if is_open() then
        vim.api.nvim_win_close(state.winid, true)
    end

    state.winid = nil
    state.visible = false
end

function M.toggle()
    if state.visible then
        M.close()
        return
    end

    state.visible = true
    M.refresh()
end

function M.setup()
    local group = vim.api.nvim_create_augroup("HarpoonMarks", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "VimResized" }, {
        group = group,
        callback = function()
            vim.schedule(M.refresh)
        end,
    })

    require("harpoon"):extend({
        ADD = vim.schedule_wrap(M.refresh),
        REMOVE = vim.schedule_wrap(M.refresh),
        LIST_CHANGE = vim.schedule_wrap(M.refresh),
        NAVIGATE = vim.schedule_wrap(M.refresh),
    })
end

return M
