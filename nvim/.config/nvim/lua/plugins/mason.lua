local function get_mason_config()
  return require "configs.mason-config"
end

return {
  -- Mason core (must load before LSP, not lazy)
  {
    "williamboman/mason.nvim",
    lazy = false,
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = function()
      local cfg = get_mason_config()
      return {
        ui = cfg.ui,
      }
    end,
    config = function(_, opts)
      local mason = require "mason"
      mason.setup(opts)
    end,
  },

  -- Mason LSP installer (must load before lspconfig, not lazy)
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      return get_mason_config().lspconfig
    end,
    config = function(_, opts)
      local mason_lspconfig = require "mason-lspconfig"
      mason_lspconfig.setup(opts)
    end,
  },
}
