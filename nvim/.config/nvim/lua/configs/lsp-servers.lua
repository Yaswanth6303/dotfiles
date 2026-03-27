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
vim.lsp.config.tailwindcss = { on_attach = disable_formatting }

-- C/C++
vim.lsp.config.clangd = { on_attach = disable_formatting }

-- Python
vim.lsp.config.pyright = { on_attach = disable_formatting }

-- Java
vim.lsp.config.jdtls = { on_attach = disable_formatting }

-- Nix
vim.lsp.config.nil_ls = { on_attach = disable_formatting }

-- GraphQL / Svelte / Prisma
vim.lsp.config.graphql = { on_attach = disable_formatting }
vim.lsp.config.svelte = { on_attach = disable_formatting }
vim.lsp.config.prismals = { on_attach = disable_formatting }

-- SQL
vim.lsp.config.sqls = { on_attach = disable_formatting }

-- Docker
vim.lsp.config.dockerls = { on_attach = disable_formatting }
vim.lsp.config.docker_compose_language_service = { on_attach = disable_formatting }

-- TOML / XML
vim.lsp.config.taplo = { on_attach = disable_formatting }
vim.lsp.config.lemminx = { on_attach = disable_formatting }

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
