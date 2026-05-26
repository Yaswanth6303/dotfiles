local options = {
  formatters = {
    ["google-java-format"] = {
      prepend_args = { "--aosp" },
    },
  },

  formatters_by_ft = {
    -- Systems
    lua = { "stylua" },
    go = { "gofumpt", "goimports", "golines" },
    rust = { "rustfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    python = { "ruff_organize_imports", "ruff_format" },
    java = { "google-java-format" },
    nix = { "alejandra" },
    bzl = { "buildifier" },

    -- MERN stack — prettierd (daemon, fast) with prettier as fallback
    -- ESLint fixes are applied separately by the ESLint LSP on BufWritePre
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    less = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    jsonc = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    graphql = { "prettierd", "prettier", stop_after_first = true },

    -- Other
    sql = { "sql_formatter" },
    dart = { "dart_format" },
    kotlin = { "ktfmt" },
    typst = { "typstyle" },
  },

  -- Function form supports `:FormatToggle` (see autocmds.lua) to disable
  -- format-on-save globally (`vim.g.disable_autoformat`) or per-buffer
  -- (`vim.b.disable_autoformat`) — useful for legacy code with intentional style.
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 3000, lsp_format = "fallback" }
  end,
}

return options
