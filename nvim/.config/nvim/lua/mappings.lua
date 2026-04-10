require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- LSP rename
map("n", "<leader>rn", function()
  require("nvchad.lsp.renamer")()
end, { desc = "LSP rename symbol" })

-- Manual format with conform
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format file with conform" })

-- Debugging
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle breakpoint" })
map("n", "<leader>dc", "<cmd>DapContinue<cr>", { desc = "Start/Continue" })
map("n", "<leader>do", "<cmd>DapStepOver<cr>", { desc = "Step over" })
map("n", "<leader>di", "<cmd>DapStepInto<cr>", { desc = "Step into" })
map("n", "<leader>dO", "<cmd>DapStepOut<cr>", { desc = "Step out" })
map("n", "<leader>dt", "<cmd>DapTerminate<cr>", { desc = "Terminate" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle UI" })

map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Markdown
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown: Browser preview" })
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Markdown: Toggle in-buffer render" })
map("n", "<leader>mg", "<cmd>Glow<cr>", { desc = "Markdown: Glow floating preview" })

-- Flutter
map("n", "<leader>Fr", "<cmd>FlutterRun<cr>", { desc = "Flutter: Run" })
map("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter: Quit" })
map("n", "<leader>Fh", "<cmd>FlutterReload<cr>", { desc = "Flutter: Hot reload" })
map("n", "<leader>FR", "<cmd>FlutterRestart<cr>", { desc = "Flutter: Hot restart" })
map("n", "<leader>Fd", "<cmd>FlutterDevices<cr>", { desc = "Flutter: Devices" })
map("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>", { desc = "Flutter: Emulators" })
map("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", { desc = "Flutter: Widget outline" })
map("n", "<leader>Fl", "<cmd>FlutterLogClear<cr>", { desc = "Flutter: Clear log" })

-- SQL (dadbod)
map("n", "<leader>St", "<cmd>DBUIToggle<cr>", { desc = "SQL: Toggle DBUI sidebar" })
map("n", "<leader>Sq", "<cmd>DBUIFindBuffer<cr>", { desc = "SQL: Find query buffer" })
map("n", "<leader>Sa", "<cmd>DBUIAddConnection<cr>", { desc = "SQL: Add connection" })

-- Typst
map("n", "<leader>Tp", "<cmd>TypstPreviewToggle<cr>", { desc = "Typst: Toggle live preview" })
map("n", "<leader>Tw", function()
  -- Compile and show word count
  local file = vim.fn.expand "%:p"
  vim.fn.jobstart({ "typst", "compile", file }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.schedule(function()
          vim.notify("Typst: Compiled → " .. file:gsub("%.typ$", ".pdf"), vim.log.levels.INFO)
        end)
      else
        vim.schedule(function()
          vim.notify("Typst: Compilation failed", vim.log.levels.ERROR)
        end)
      end
    end,
  })
end, { desc = "Typst: Compile to PDF" })
map("n", "<leader>Ts", "<cmd>TypstPreviewSyncCursor<cr>", { desc = "Typst: Sync cursor to preview" })
map("n", "<leader>Tf", function()
  -- Quick follow mode toggle
  require("typst-preview").set_follow_cursor(not require("typst-preview").get_follow_cursor())
end, { desc = "Typst: Toggle follow cursor" })
