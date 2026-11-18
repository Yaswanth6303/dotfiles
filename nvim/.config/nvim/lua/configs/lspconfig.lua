require("nvchad.configs.lspconfig").defaults()

vim.diagnostic.config {
  virtual_text = { prefix = "●", spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
}

local mason_cfg = require("configs.mason-config").lspconfig
local servers = mason_cfg.ensure_installed

-- per-server settings must exist before enable: enable starts servers for already-open buffers
require "configs.lsp-servers"
vim.lsp.enable(servers)
