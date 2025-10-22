return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls", -- TypeScript/JavaScript language server (replaces deprecated tsserver)
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        -- Systems programming
        "clangd", -- C/C++
        "gopls", -- Go
        "rust_analyzer", -- Rust
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        -- "stylua", -- lua formatter (installed via Nix)
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
        -- Systems programming tools
        "clang-format", -- C/C++ formatter
        "goimports", -- Go imports formatter (includes gofmt functionality)
      },
    })
  end,
}
