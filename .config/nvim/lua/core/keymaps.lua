-- Ctrl+B toggles the fullscreen file explorer, like the sidebar toggle in Zed.
-- Replaces the stock Ctrl+B (page up); tmux's prefix moved to Ctrl+Space for this.
vim.keymap.set("n", "<C-b>", function()
    Snacks.explorer()
end, { desc = "File explorer" })

-- Ctrl+G lists all git hunks of the repo, fuzzy searchable with a diff preview.
-- Replaces the stock Ctrl+G (file info); `:file` still shows the same.
vim.keymap.set("n", "<C-g>", function()
    Snacks.picker.git_diff()
end, { desc = "Git hunks" })
