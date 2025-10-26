return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      format = {
        cmdline = { icon = "", title = " Command " }, -- default command
        search_down = { icon = "⌄", title = " Search ↓ " }, -- search forward
        search_up = { icon = "⌃", title = " Search ↑ " }, -- search backward
        lua = { icon = "", title = " Lua " }, -- lua command line
        help = { icon = "󰋖", title = " Help " }, -- help command
        filter = { icon = "", title = " Filter " }, -- filter input
      },
    },
    messages = {
      enabled = true,
      view = "notify",
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
      progress = {
        enabled = true,
        view = "mini",
      },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)

    local map = vim.keymap.set
    map("n", "<leader>nm", "<cmd>Noice<cr>", { desc = "Noice messages" })
    map("n", "<leader>nd", "<cmd>NoiceDismiss<cr>", { desc = "Dismiss notifications" })
  end,
}
