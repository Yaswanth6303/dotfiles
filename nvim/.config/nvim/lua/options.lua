require "nvchad.options"

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Faster CursorHold events (LSP hover, signature help)
opt.updatetime = 200

-- Faster which-key popup
opt.timeoutlen = 300

-- Keep context lines visible while scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Persistent undo across sessions
local undodir = vim.fn.stdpath "data" .. "/undo"
vim.fn.mkdir(undodir, "p")
opt.undodir = undodir
opt.undofile = true
