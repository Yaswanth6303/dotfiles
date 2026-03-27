-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

-- Always enable line numbers + relative numbers
vim.opt.number = true
vim.opt.relativenumber = true

M.base46 = {
  theme = "catppuccin",
  transparency = true,
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = { load_on_startup = true }

M.ui = {
  cmp = {
    icons_left = true,
    style = "default",
    -- format_colors = { lsp = true, icon = "󱓻" },
  },
}

return M
