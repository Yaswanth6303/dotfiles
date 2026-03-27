local options = {
  -- Formatter options (Java: 4-space indent only)
  formatters = {
    ["google-java-format"] = {
      prepend_args = { "--aosp" },
    },
    eslint_d = {
      condition = function(self, ctx)
        return vim.fs.find({
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.json",
          ".eslintrc.yml",
          ".eslintrc.yaml",
          ".eslintrc.cjs",
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
        }, { path = ctx.dirname, upward = true })[1] ~= nil
      end,
    },
  },

  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofumpt", "goimports", "golines" },
    rust = { "rustfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    python = { "ruff_organize_imports", "ruff_format" },
    java = { "google-java-format" },
    nix = { "alejandra" },
    bzl = { "buildifier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    sql = { "sql_formatter" },
    javascript = { "eslint_d", "prettier" },
    typescript = { "eslint_d", "prettier" },
    javascriptreact = { "eslint_d", "prettier" },
    typescriptreact = { "eslint_d", "prettier" },
    dart = { "dart_format" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

return options
