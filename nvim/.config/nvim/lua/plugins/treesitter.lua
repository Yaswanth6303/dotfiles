return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local ts_opts = require "configs.treesitter"
      opts.ensure_installed = ts_opts.ensure_installed
      return opts
    end,
  },
}
