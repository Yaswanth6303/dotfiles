return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = function(_, opts)
      local ts_opts = require "configs.treesitter"
      opts.ensure_installed = ts_opts.ensure_installed
      opts.textobjects = ts_opts.textobjects
      return opts
    end,
  },

  -- Textobjects: af/if (function), ac/ic (class), aa/ia (parameter)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
  },

  -- Sticky context header: shows current function/class at top of buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,
      min_window_height = 20,
      multiline_threshold = 1,
      trim_scope = "outer",
    },
  },
}
