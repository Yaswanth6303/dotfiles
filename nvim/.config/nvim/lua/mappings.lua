require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Manual format with conform
map("n", "<leader>fm", function() require("conform").format({ lsp_fallback = true }) end, { desc = "Format file with conform" })

-- Debugging
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>DapContinue<cr>", { desc = "Start/Continue" })
map("n", "<leader>do", "<cmd>DapStepOver<cr>", { desc = "Step over" })
map("n", "<leader>di", "<cmd>DapStepInto<cr>", { desc = "Step into" })
map("n", "<leader>dO", "<cmd>DapStepOut<cr>", { desc = "Step out" })
map("n", "<leader>dt", "<cmd>DapTerminate<cr>", { desc = "Terminate" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle UI" })
