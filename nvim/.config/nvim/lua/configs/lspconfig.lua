require("nvchad.configs.lspconfig").defaults()

-- Only show signature help when LSP returns something (suppress "No signature help available")
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  if result and result.signatures and #result.signatures > 0 then
    vim.lsp.handlers.signature_help(err, result, ctx, config)
  end
end

local servers = {
  "html",
  "cssls",
  "jsonls",
  "tailwindcss",
  "emmet_ls",
  "ts_ls",
  "eslint",
  "marksman",
  "gopls",
  "rust_analyzer",
  "clangd",
  "lua_ls",
  "pyright",
  "jdtls",
  "nil_ls",
}

vim.lsp.enable(servers)

require "configs.lsp-servers"