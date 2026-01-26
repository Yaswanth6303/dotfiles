-- LSP server-specific configurations
-- Formatting is disabled for all servers (conform.nvim handles formatting)

local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

-- Web
vim.lsp.config.ts_ls = { on_attach = disable_formatting }
vim.lsp.config.eslint = { on_attach = disable_formatting }
vim.lsp.config.html = { on_attach = disable_formatting }
vim.lsp.config.jsonls = { on_attach = disable_formatting }
vim.lsp.config.cssls = { on_attach = disable_formatting }

-- C/C++
vim.lsp.config.clangd = { on_attach = disable_formatting }

-- Python
vim.lsp.config.pyright = { on_attach = disable_formatting }

-- Lua (Neovim config)
vim.lsp.config.lua_ls = {
  on_attach = disable_formatting,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
}
