require("nvchad.configs.lspconfig").defaults()

-- Only show signature help when LSP returns something (suppress "No signature help available")
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  if result and result.signatures and #result.signatures > 0 then
    vim.lsp.handlers.signature_help(err, result, ctx, config)
  end
end

local mason_cfg = require("configs.mason-config").lspconfig
local servers = mason_cfg.ensure_installed

vim.lsp.enable(servers)

require "configs.lsp-servers"