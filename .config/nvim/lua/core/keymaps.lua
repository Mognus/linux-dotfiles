-- Space as leader. Must be set before any <leader> mapping is defined;
-- no plugin loaded before this file defines one.
vim.g.mapleader = " "

-- Code actions live under <leader>; navigation uses short g mappings.
-- which-key reads each mapping's description for its help popup.
-- Groups: c = code, f = find, g = git, x = diagnostics (named in plugins.lua).

vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ keys = "", mode = "n" })
end, { desc = "Show key help" })

vim.keymap.set("x", "<leader>?", function()
    require("which-key").show({ keys = "", mode = "x" })
end, { desc = "Show visual key help" })

vim.keymap.set({ "n", "x" }, "<leader>aa", function()
    require("opencode").ask("@this: ")
end, { desc = "Ask OpenCode about cursor or selection" })

vim.keymap.set({ "n", "x" }, "<leader>as", function()
    require("opencode").select()
end, { desc = "Select OpenCode action" })

vim.keymap.set("n", "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Go to definition" })

-- Keep both the short mapping and Neovim's familiar grr spelling.
local function find_references()
    Snacks.picker.lsp_references()
end

vim.keymap.set("n", "gr", find_references, { desc = "Find references" })
vim.keymap.set("n", "grr", find_references, { desc = "Find references" })
vim.keymap.set("n", "grt", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Go to type definition" })
vim.keymap.set("n", "gri", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Find implementations" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>cl", "<cmd>lsp restart<CR>", { desc = "Restart buffer language servers" })
vim.keymap.set("n", "<leader>ct", "<cmd>TSC<CR>", { desc = "Type-check TypeScript project" })
vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Space+c+f formats the current buffer using the filetype map in core/format.lua.
vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ async = true })
end, { desc = "Format buffer" })

-- Space+g+d toggles a side-by-side diff of the current file against git
-- (built-in diff mode). ]c / [c jump between changes.
-- The git side is a buffer named "gitsigns://...": if one is open, pressing
-- again closes it; otherwise it opens one.
-- Example: 1× Space+g+d → "file | gitsigns://.../file", 2× → back to "file".
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

vim.keymap.set("n", "<leader>gd", toggle_git_diff, { desc = "Toggle git diff of current file" })

-- Space+e toggles the fullscreen file explorer.
vim.keymap.set("n", "<leader>e", function()
    Snacks.explorer()
end, { desc = "File explorer" })

-- Space+g+s lists all changed files of the repo, including new (untracked) ones,
-- fuzzy searchable with a diff preview. git diff alone never shows new files.
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

vim.keymap.set("n", "<leader>gs", function()
    local root = Snacks.git.get_root()
    if root == nil then
        vim.notify("Not in a git repository", vim.log.levels.WARN)
        return
    end
    open_git_status(root)
end, { desc = "Git changed files" })

-- Space+f+f finds files across the whole git repo.
vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files({
        cwd = Snacks.git.get_root(),
        hidden = true,
    })
end, { desc = "Find files in repo" })

-- Space+f+s finds LSP symbols in this file; Space+f+S searches the workspace live.
vim.keymap.set("n", "<leader>fs", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Find symbols in file" })

vim.keymap.set("n", "<leader>fS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "Find symbols in workspace" })

-- Space+/ greps across the whole git repo, dotfiles included (.git stays excluded).
vim.keymap.set("n", "<leader>/", function()
    Snacks.picker.grep({ cwd = Snacks.git.get_root(), hidden = true })
end, { desc = "Grep in repo" })

-- Space+x+x lists published diagnostics from LSPs and project checks (tsc.nvim).
vim.keymap.set("n", "<leader>xx", function()
    Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
