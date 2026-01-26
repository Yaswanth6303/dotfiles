local function get_mason_config()
  return require "configs.mason-config"
end

return {
  -- Mason tool installer (auto-installs formatters/linters on startup)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      return {
        ensure_installed = get_mason_config().tools,
        auto_update = false,
        run_on_start = true,
      }
    end,
  },

  -- Formatter (format on save)
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "BufWritePre",
    opts = require "configs.conform",
  },
}
