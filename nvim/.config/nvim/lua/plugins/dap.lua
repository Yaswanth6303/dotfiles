return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Start/Continue" },
      { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step over" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step into" },
      { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step out" },
      { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
    },
    cmd = { "DapToggleBreakpoint", "DapContinue", "DapNew", "DapStepOver", "DapStepInto", "DapStepOut" },
    config = function()
      require "configs.dap"
    end,
  },

  -- Mason DAP installer (auto-configures adapters)
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      -- nvim-dap adapter names, not Mason package names: python = debugpy, js = js-debug-adapter
      ensure_installed = { "codelldb", "delve", "python", "js" },
      handlers = {},
    },
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
    },
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
