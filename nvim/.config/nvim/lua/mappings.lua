require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Snacks picker: same keys as NvChad's Telescope maps (overridden here), plus a few extras
local function pick(source, opts)
  return function()
    Snacks.picker[source](opts)
  end
end
map("n", "<leader>ff", pick "files", { desc = "\u{f15b} Find files" })
map("n", "<leader>fa", pick("files", { ignored = true }), { desc = "\u{f15b} Find all files (incl. git-ignored)" })
map("n", "<leader>fw", pick "grep", { desc = "\u{f002} Live grep" })
map({ "n", "x" }, "<leader>fW", pick "grep_word", { desc = "\u{f002} Grep word / selection" })
map("n", "<leader>fb", pick "buffers", { desc = "\u{f0c5} Buffers" })
map("n", "<leader>fo", pick "recent", { desc = "\u{f1da} Recent files" })
map("n", "<leader>fz", pick "lines", { desc = "\u{f0cb} Search in current buffer" })
map("n", "<leader>fh", pick "help", { desc = "\u{f059} Help pages" })
map("n", "<leader>fk", pick "keymaps", { desc = "\u{f11c} Keymaps" })
map("n", "<leader>fd", pick "diagnostics", { desc = "\u{f188} Diagnostics" })
map("n", "<leader>fs", pick "lsp_symbols", { desc = "\u{f1b2} LSP symbols" })
map("n", "<leader>fu", pick "undo", { desc = "\u{f0e2} Undo history" })
map("n", "<leader>fi", pick "icons", { desc = "\u{f118} Icons" })
map("n", "<leader>fc", pick("files", { cwd = vim.fn.stdpath "config" }), { desc = "\u{f013} Neovim config files" })
map("n", "<leader>fr", pick "resume", { desc = "\u{f01e} Resume last picker" })
map("n", "<leader>f<space>", pick "pickers", { desc = "\u{f0ca} All pickers" })
map("n", "<leader>ma", pick "marks", { desc = "\u{f02e} Marks" })
-- Remove NvChad's Alt+h / Alt+v / Alt+i terminal toggles (<leader>h / <leader>v still open terminals)
for _, key in ipairs { "<A-h>", "<A-v>", "<A-i>" } do
  pcall(vim.keymap.del, { "n", "t" }, key)
end

pcall(vim.keymap.del, "n", "<leader>cm") -- NvChad's Telescope commits; moved to <leader>gc
map("n", "<leader>gc", pick "git_log", { desc = "\u{e702} Git commits" })
map("n", "<leader>gt", pick "git_status", { desc = "\u{e702} Git status" })

-- Snacks gh: GitHub issues / PRs for the current repo (needs `gh auth login`)
map("n", "<leader>gi", pick "gh_issue", { desc = "\u{f09b} GitHub issues (open)" })
map("n", "<leader>gI", pick("gh_issue", { state = "all" }), { desc = "\u{f09b} GitHub issues (all)" })
map("n", "<leader>gp", pick "gh_pr", { desc = "\u{f09b} GitHub PRs (open)" })
map("n", "<leader>gP", pick("gh_pr", { state = "all" }), { desc = "\u{f09b} GitHub PRs (all)" })

-- LSP rename
map("n", "<leader>rn", function()
  require "nvchad.lsp.renamer"()
end, { desc = "LSP rename symbol" })

-- Manual format with conform
map("n", "<leader>fm", function()
  require("conform").format { lsp_format = "fallback" }
end, { desc = "Format file with conform" })

-- Windows / tabs
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Register which-key group headers so pressing <leader> shows named sections
local ok, wk = pcall(require, "which-key")
if ok and wk.add then
  wk.add {
    { "<leader>F", group = "Flutter" },
    { "<leader>f", group = "Find (Snacks picker)" },
    { "<leader>g", group = "Git / GitHub" },
    { "<leader>p", group = "Profiler" },
    { "<leader>u", group = "Toggles" },
    { "<leader>S", group = "SQL / DBUI" },
    { "<leader>T", group = "Typst" },
    { "<leader>d", group = "Debug" },
    { "<leader>m", group = "Markdown" },
    { "<leader>s", group = "Split" },
    { "<leader>t", group = "Tab" },
  }
end
