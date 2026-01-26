require("nvchad.configs.lspconfig").defaults()

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
}

vim.lsp.enable(servers)

require "configs.lsp-servers"