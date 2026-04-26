local M = {}

local function get_outermost_git_root()
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = current_file ~= "" and vim.fs.dirname(current_file) or vim.uv.cwd()
    local root = vim.fn.systemlist({ "git", "-C", current_dir, "rev-parse", "--show-toplevel" })[1]

    if vim.v.shell_error ~= 0 or not root or root == "" then
        return current_dir
    end

    while true do
        local super_root = vim.fn.systemlist({ "git", "-C", root, "rev-parse", "--show-superproject-working-tree" })[1]

        if vim.v.shell_error ~= 0 or not super_root or super_root == "" then
            return root
        end

        root = super_root
    end
end

local function git_changed_files(repo)
    local files = {}
    local lines = vim.fn.systemlist({ "git", "-C", repo, "status", "--porcelain", "--untracked-files=all" })

    for _, line in ipairs(lines) do
        local status = line:sub(1, 2)
        local path = line:sub(4)
        path = path:match(".* %-> (.*)") or path

        local abs = repo .. "/" .. path
        local is_submodule = vim.fn.isdirectory(abs) == 1
            and (vim.fn.isdirectory(abs .. "/.git") == 1 or vim.fn.filereadable(abs .. "/.git") == 1)

        if not is_submodule then
            table.insert(files, { status = status, name = path, path = abs })
        end
    end

    return files
end

function M.open_workspace_status()
    local root = get_outermost_git_root()
    local modules = { { name = vim.fs.basename(root), repo = root } }
    local submodules = vim.fn.systemlist({
        "git",
        "-C",
        root,
        "submodule",
        "foreach",
        "--quiet",
        "--recursive",
        "printf '%s\\n' \"$displaypath\"",
    })
    local lines, paths = {}, {}

    for _, name in ipairs(submodules) do
        table.insert(modules, { name = name, repo = root .. "/" .. name })
    end

    for _, module in ipairs(modules) do
        local files = git_changed_files(module.repo)

        if #files > 0 then
            table.insert(lines, module.name)

            for _, file in ipairs(files) do
                table.insert(lines, string.format("  %s  %s", file.status, file.name))
                paths[#lines] = file.path
            end

            table.insert(lines, "")
        end
    end

    if #lines == 0 then
        vim.notify("Git workspace clean")
        return
    end

    local origin = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].filetype = "git"
    vim.bo[buf].modifiable = false
    vim.b[buf].paths = paths

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.75),
        height = math.min(#lines + 2, math.floor(vim.o.lines * 0.7)),
        row = 3,
        col = math.floor(vim.o.columns * 0.125),
        border = "rounded",
        title = " Git Workspace ",
        title_pos = "center",
    })

    vim.keymap.set("n", "<CR>", function()
        local path = vim.b[buf].paths[vim.api.nvim_win_get_cursor(0)[1]]
        if not path then
            return
        end

        vim.api.nvim_win_close(win, true)
        if vim.api.nvim_win_is_valid(origin) then
            vim.api.nvim_set_current_win(origin)
        end
        vim.cmd.edit(vim.fn.fnameescape(path))
    end, { buffer = buf })

    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })

    vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
end

return M
