return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {
    -- 🍿 Notification system
    notifier = {
      enabled = true,
      style = "compact", -- or "minimal", "fancy"
      timeout = 3000, -- milliseconds before auto-close
      border = "rounded",
      max_width = 60,
      max_height = 10,
      icons = {
        info = " ",
        warn = " ",
        error = " ",
        success = " ",
      },
      level = vim.log.levels.INFO,
    },

    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },

    -- 💬 Floating input box (optional)
    input = {
      enabled = true,
      border = "rounded",
      win_options = {
        winblend = 10,
      },
    },

    -- 🧠 Floating terminal (optional)
    terminal = {
      enabled = true,
      direction = "float",
      float_opts = {
        border = "rounded",
        width = 100,
        height = 30,
      },
    },

    -- ⚙️ Optional command line popup (set true if you want)
    cmdline = {
      enabled = false,
    },
  },

  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (cwd)",
    },
  },

  config = function(_, opts)
    local snacks = require("snacks")
    snacks.setup(opts)

    local map = vim.keymap.set

    -- 🍿 Test Notification
    map("n", "<leader>snt", function()
      snacks.notifier.notify("Hello from Snacks 🍿!", {
        level = "info",
        title = "Snacks Notification",
      })
    end, { desc = "Show test notification" })

    -- 🕘 Notification History
    map("n", "<leader>snh", function()
      snacks.notifier.show_history()
    end, { desc = "Show notification history" })

    -- 🧠 Toggle Floating Terminal
    map("n", "<leader>st", function()
      snacks.terminal.toggle()
    end, { desc = "Toggle terminal" })
  end,
}
