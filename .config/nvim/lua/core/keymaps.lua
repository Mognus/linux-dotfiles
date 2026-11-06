-- Space as leader. Must be set before any <leader> mapping is defined;
-- no plugin loaded before this file defines one.
vim.g.mapleader = " "

-- Code actions live under <leader>; navigation uses short g mappings.
-- which-key reads each mapping's description for its help popup.
-- Groups: c = code, f = find, g = git, x = diagnostics (named in plugins.lua).

-- Hold Ctrl+n/p to switch tab pages; leader actions create or close them.
-- Insert-mode completion stays unchanged; Alt+n/p remains reserved for tmux.
vim.keymap.set("n", "<C-n>", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<C-p>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>n", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>q", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- Mirror Super/Alt+Shift+Enter and j/k for desktop windows and tmux panes.
vim.keymap.set("n", "<C-S-CR>", "<cmd>rightbelow vsplit<CR>", { desc = "New split" })
vim.keymap.set("n", "<C-j>", "<C-w>w", { desc = "Next window" })
vim.keymap.set("n", "<C-k>", "<C-w>W", { desc = "Previous window" })

-- Mark text, Space+c+w, then a delimiter or t + tag name + Enter.
vim.keymap.set("x", "<leader>cw", "<Plug>(nvim-surround-visual)", { desc = "Wrap selection" })

-- Flash's recommended mappings; r/R only replace keys in the modes below.
vim.keymap.set({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "Flash jump" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter selection" })

vim.keymap.set("o", "r", function()
    require("flash").remote()
end, { desc = "Flash remote action" })

vim.keymap.set({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
end, { desc = "Flash Treesitter search" })

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

local function find_references()
    Snacks.picker.lsp_references()
end

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

vim.keymap.set("n", "<leader>gd", function()
    Snacks.picker.git_diff()
end, { desc = "Git diffs" })

-- Space+e toggles the Snacks file explorer in fullscreen.
vim.keymap.set("n", "<leader>e", function()
    Snacks.explorer()
end, { desc = "File explorer" })

vim.keymap.set("n", "<leader>gs", function()
    Snacks.picker.git_status()
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

-- Space+x+e shows full diagnostics for this line and focuses the scrollable float.
vim.keymap.set("n", "<leader>xe", function()
    local _, win = vim.diagnostic.open_float({ scope = "line", source = true })
    if win then
        vim.api.nvim_set_current_win(win)
    end
end, { desc = "Explain diagnostic" })

-- Space+x+d toggles inline diagnostic text; signs and other diagnostics stay active.
vim.keymap.set("n", "<leader>xd", function()
    local enabled = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = enabled })
    vim.notify("Inline diagnostics " .. (enabled and "enabled" or "disabled"))
end, { desc = "Toggle inline diagnostics" })
