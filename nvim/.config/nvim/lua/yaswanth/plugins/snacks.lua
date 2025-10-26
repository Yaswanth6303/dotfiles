return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {
    notifier = {
      enabled = true,
      style = "fancy",
      timeout = 3000,
      icons = {
        info = " ",
        warn = " ",
        error = " ",
        success = " ",
      },
    },
    input = {
      enabled = true,
      border = "rounded",
      win_options = {
        winblend = 10,
      },
    },
    terminal = {
      enabled = true,
      direction = "float",
      float_opts = {
        border = "rounded",
        width = 100,
        height = 30,
      },
    },
  },
  config = function(_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)
    local map = vim.keymap.set

    map("n", "<leader>bsn", function()
      snacks.notifier.notify("Hello from Snacks 🍿!", {
        level = "info",
        title = "Snacks Notification",
      })
    end, { desc = "Show test notification" })

    map("n", "<leader>bsh", function()
      snacks.notifier.show_history()
    end, { desc = "Show notification history" })

    map("n", "<leader>st", function()
      snacks.terminal.toggle()
    end, { desc = "Toggle terminal" })
  end,
}
