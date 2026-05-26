return {
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim", -- JSON/YAML schemas for package.json, tsconfig, etc.
    },
    config = function()
      require "configs.lspconfig"
    end,
  },
}
