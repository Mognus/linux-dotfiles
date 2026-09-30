-- Ctrl+B toggles the fullscreen file explorer, like the sidebar toggle in Zed.
-- Replaces the stock Ctrl+B (page up); tmux's prefix moved to Ctrl+Space for this.
vim.keymap.set("n", "<C-b>", function()
    Snacks.explorer()
end, { desc = "File explorer" })
