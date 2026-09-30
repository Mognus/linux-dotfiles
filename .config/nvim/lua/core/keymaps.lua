-- Space as leader. Must be set before any <leader> mapping is defined;
-- no plugin loaded before this file defines one.
vim.g.mapleader = " "

-- Space+d toggles a side-by-side diff of the current file against git
-- (built-in diff mode). ]c / [c jump between changes.
-- The git side is a buffer named "gitsigns://...": if one is open, pressing
-- again closes it; otherwise it opens one.
-- Example: 1× Space+d → "file | gitsigns://.../file", 2× → back to "file".
local function toggle_git_diff()
    local closed = false
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
        if vim.startswith(name, "gitsigns://") then
            vim.api.nvim_win_close(win, true)
            closed = true
        end
    end

    if closed then
        -- The remaining window still has diff mode on; turn it off.
        vim.cmd("diffoff!")
        return
    end

    require("gitsigns").diffthis()
end

vim.keymap.set("n", "<leader>d", toggle_git_diff, { desc = "Toggle git diff of current file" })

-- Ctrl+B toggles the fullscreen file explorer, like the sidebar toggle in Zed.
-- Replaces the stock Ctrl+B (page up); tmux's prefix moved to Ctrl+Space for this.
vim.keymap.set("n", "<C-b>", function()
    Snacks.explorer()
end, { desc = "File explorer" })

-- Ctrl+G lists all changed files of the repo, including new (untracked) ones,
-- fuzzy searchable with a diff preview. git diff alone never shows new files.
-- Replaces the stock Ctrl+G (file info); `:file` still shows the same.
-- Outside a repo git fails with error prompts, so check first.
--
-- git status lists a submodule as one entry ("M repos/traeno-pm") and never
-- its files, so Enter on a submodule opens the git status of that submodule.
-- Example: Enter on "repos/traeno-pm" → picker with "?? .../i18n/de.po".
-- Ctrl+G inside the picker goes back up to the parent repo.
local function open_git_status(root)
    Snacks.picker.git_status({
        cwd = root,
        win = {
            input = { keys = { ["<C-g>"] = { "git_parent", mode = { "n", "i" } } } },
            list = { keys = { ["<C-g>"] = "git_parent" } },
        },
        actions = {
            -- Example: root ".../deci-wrapper/repos/traeno-pm" → picker for ".../deci-wrapper".
            git_parent = function(picker)
                local result = vim.system(
                    { "git", "rev-parse", "--show-superproject-working-tree" },
                    { cwd = root, text = true }
                ):wait()
                local parent = vim.trim(result.stdout or "")
                if parent == "" then
                    vim.notify("Already in the top-level repository", vim.log.levels.INFO)
                    return
                end
                picker:close()
                open_git_status(parent)
            end,
        },
        confirm = function(picker, item, action)
            local path = item.cwd .. "/" .. item.file
            -- Submodules have a .git file in their folder; normal files don't.
            if vim.uv.fs_stat(path .. "/.git") == nil then
                Snacks.picker.actions.jump(picker, item, action)
                return
            end
            picker:close()
            open_git_status(path)
        end,
    })
end

vim.keymap.set("n", "<C-g>", function()
    local root = Snacks.git.get_root()
    if root == nil then
        vim.notify("Not in a git repository", vim.log.levels.WARN)
        return
    end
    open_git_status(root)
end, { desc = "Git changed files" })

-- Ctrl+P finds files across the whole git repo, like the file finder in Zed.
-- Replaces the stock Ctrl+P (line up); k does the same.
vim.keymap.set("n", "<C-p>", function()
    Snacks.picker.files({ cwd = Snacks.git.get_root() })
end, { desc = "Find files in repo" })

-- Ctrl+/ greps across the whole git repo. Terminals send Ctrl+/ as Ctrl+_,
-- so both are mapped.
local function grep_repo()
    Snacks.picker.grep({ cwd = Snacks.git.get_root() })
end
vim.keymap.set("n", "<C-/>", grep_repo, { desc = "Grep in repo" })
vim.keymap.set("n", "<C-_>", grep_repo, { desc = "Grep in repo" })
