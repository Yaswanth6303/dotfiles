return {
  {
    "akinsho/flutter-tools.nvim",
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter: Run" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter: Quit" },
      { "<leader>Fh", "<cmd>FlutterReload<cr>", desc = "Flutter: Hot reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter: Hot restart" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter: Devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter: Emulators" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: Widget outline" },
      { "<leader>Fl", "<cmd>FlutterLogClear<cr>", desc = "Flutter: Clear log" },
    },
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      ui = {
        border = "rounded",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      widget_guides = { enabled = true },
      closing_tags = { enabled = true },
      lsp = {
        -- `color = {...}` removed: deprecated in flutter-tools for Neovim 0.12+.
        -- Document colors enabled below via the native vim.lsp.document_color API.
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          if vim.lsp.document_color and vim.lsp.document_color.enable then
            pcall(vim.lsp.document_color.enable, true, bufnr)
          end
        end,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "prompt",
          enableSnippets = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
    },
  },
}
