local M = {}

local function current_dir()
    local current_file = vim.api.nvim_buf_get_name(0)

    if current_file ~= "" then
        return vim.fs.dirname(current_file)
    end

    return vim.uv.cwd()
end

local function systemlist(cmd)
    local lines = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 then
        return {}
    end

    return lines
end

local function outermost_git_root()
    local root = systemlist({ "git", "-C", current_dir(), "rev-parse", "--show-toplevel" })[1]

    if not root or root == "" then
        return current_dir()
    end

    while true do
        local super_root = systemlist({ "git", "-C", root, "rev-parse", "--show-superproject-working-tree" })[1]

        if not super_root or super_root == "" then
            return root
        end

        root = super_root
    end
end

local function submodule_paths(root)
    return systemlist({
        "git",
        "-C",
        root,
        "submodule",
        "foreach",
        "--quiet",
        "--recursive",
        "printf '%s\\n' \"$displaypath\"",
    })
end

local function changed_files(repo, module_name)
    local items = {}
    local lines = systemlist({ "git", "-C", repo, "status", "--porcelain", "--untracked-files=all" })

    for _, line in ipairs(lines) do
        local status = line:sub(1, 2)
        local path = line:sub(4)
        path = path:match(".* %-> (.*)") or path

        local absolute = repo .. "/" .. path
        local label = module_name == "." and path or module_name .. "/" .. path

        items[#items + 1] = {
            text = string.format("%s  %s", status, label),
            file = absolute,
            pos = { 1, 0 },
            item = {
                status = status,
                module = module_name,
                path = path,
            },
        }
    end

    return items
end

function M.workspace_status()
    local root = outermost_git_root()
    local modules = { { name = ".", repo = root } }

    for _, path in ipairs(submodule_paths(root)) do
        modules[#modules + 1] = { name = path, repo = root .. "/" .. path }
    end

    local items = {}

    for _, module in ipairs(modules) do
        vim.list_extend(items, changed_files(module.repo, module.name))
    end

    if #items == 0 then
        vim.notify("Git workspace clean")
        return
    end

    Snacks.picker({
        title = "Git Workspace Status",
        finder = function()
            return items
        end,
        format = function(item)
            local status = item.item.status
            local module = item.item.module == "." and "root" or item.item.module
            local path = item.item.path

            return {
                { status, "DiagnosticWarn" },
                { "  " },
                { module, "Comment" },
                { "  " },
                { path },
            }
        end,
        preview = "file",
    })
end

return M
