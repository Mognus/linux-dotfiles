vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Input and terminal integration.
opt.mouse = "a" -- Enable mouse support in all modes.
opt.clipboard = "unnamedplus" -- Use the system clipboard by default.
opt.termguicolors = true -- Enable true color terminal rendering.

-- Keep navigation context visible.
opt.number = true -- Show absolute line number on the cursor line.
opt.relativenumber = true -- Show relative line numbers around the cursor.
opt.signcolumn = "yes" -- Reserve space for Git/LSP signs.
opt.cursorline = true -- Highlight the current line.
opt.scrolloff = 8 -- Keep vertical context around the cursor.
opt.sidescrolloff = 8 -- Keep horizontal context around the cursor.

-- Default indentation for new files.
opt.expandtab = true -- Insert spaces instead of tab characters.
opt.shiftwidth = 4 -- Use four spaces for indentation.
opt.tabstop = 4 -- Display tab characters as four columns.
opt.smartindent = true -- Auto-indent new lines from context.

-- Search like modern editors: live, highlighted, case-smart.
opt.ignorecase = true -- Ignore case in searches by default.
opt.smartcase = true -- Respect case when the query contains uppercase.
opt.incsearch = true -- Show matches while typing the search.
opt.hlsearch = true -- Highlight all current search matches.

-- Window and editing behavior.
opt.splitright = true -- Open vertical splits to the right.
opt.splitbelow = true -- Open horizontal splits below.
opt.showmode = true -- No statusline plugin, so the built-in mode text is needed.
opt.wrap = false -- Keep long lines on one visual line.
opt.confirm = true -- Ask before closing buffers with unsaved changes.
opt.undofile = true -- Persist undo history across sessions.
opt.updatetime = 250 -- Make CursorHold/Git/LSP updates feel responsive.
opt.timeoutlen = 400 -- Keep key-chord waiting time short.
