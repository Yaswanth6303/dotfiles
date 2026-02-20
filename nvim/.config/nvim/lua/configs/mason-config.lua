return {
  -- Mason core UI configuration
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },

  -- Mason LSP config
  lspconfig = {
    ensure_installed = {
      "rust_analyzer",
      "gopls",
      "lua_ls",
      "ts_ls",
      "eslint",
      "html",
      "cssls",
      "jsonls",
      "tailwindcss",
      "emmet_ls",
      "marksman",
      "clangd",
      "pyright",
      "jdtls",
      "nil_ls",
    },
    automatic_installation = true,
  },

  -- Mason tools to auto-install (formatters, linters)
  tools = {
    "stylua",
    "gofumpt",
    "goimports",
    "golines",
    "prettier",
    "eslint_d",
    "clang-format",
    "ruff",
    "google-java-format",
    "alejandra",
  },
}
