return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    keys = {
      { "<leader>St", "<cmd>DBUIToggle<cr>", desc = "SQL: Toggle DBUI sidebar" },
      { "<leader>Sq", "<cmd>DBUIFindBuffer<cr>", desc = "SQL: Find query buffer" },
      { "<leader>Sa", "<cmd>DBUIAddConnection<cr>", desc = "SQL: Add connection" },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = { "tpope/vim-dadbod" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40
      vim.g.db_ui_execute_table_helper = "<leader>Sr"
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = { "kristijanhusak/vim-dadbod-ui" },
    config = function()
      local cmp = require "cmp"
      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
