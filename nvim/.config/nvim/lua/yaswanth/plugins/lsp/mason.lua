return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
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
        "clangd",        -- C/C++
        "gopls",         -- Go
        "rust_analyzer", -- Rust
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        -- "stylua", -- lua formatter (installed via Nix)
        "isort",    -- python formatter
        "black",    -- python formatter
        "pylint",
        "eslint_d",
        -- Systems programming tools
        "clang-format", -- C/C++ formatter
        "goimports",    -- Go imports formatter (includes gofmt functionality)
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
