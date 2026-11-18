-- LSP server-specific settings. Which servers run is decided by configs/mason-config.lua.
-- Every server uses the call form `vim.lsp.config("name", {...})`: it merges into nvim-lspconfig's
-- defaults, while `vim.lsp.config.name = {...}` replaces earlier user config (bit lua_ls once).
-- Servers that need nothing beyond nvim-lspconfig's defaults are not listed here.

-- lspconfig lists some filetypes Neovim never sets (e.g. 'mdx', 'gotmpl'); keep only real ones
-- shortcut: uses private vim.filetype._get_known_filetypes (same as :checkhealth); swap if it's removed
local known_ft = vim.filetype._get_known_filetypes()
local function known_filetypes(name)
  return vim.tbl_filter(function(ft)
    return known_ft[ft]
  end, vim.lsp.config[name].filetypes)
end

--------------------------------------------------------------------------------
-- Shared behaviour (LspAttach instead of per-server on_attach, so nvim-lspconfig's
-- own on_attach keeps working, e.g. :LspClangdSwitchSourceHeader, :LspEslintFixAll)
--------------------------------------------------------------------------------

--- ESLint: apply `source.fixAll.eslint` before each save.
local function eslint_fix_on_save(client, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("eslint_fix_on_save_" .. bufnr, { clear = true }), -- no stacking on re-attach
    buffer = bufnr,
    callback = function()
      local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
      params.context = { only = { "source.fixAll.eslint" }, diagnostics = {} }
      local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
      for _, res in pairs(results or {}) do
        for _, action in ipairs(res.result or {}) do
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          end
        end
      end
    end,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_shared_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    -- conform.nvim owns formatting; stop servers from formatting too
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    if client.name == "eslint" then
      eslint_fix_on_save(client, args.buf)
    end
  end,
})

--------------------------------------------------------------------------------
-- Go
--------------------------------------------------------------------------------
vim.lsp.config("gopls", {
  filetypes = known_filetypes "gopls",
  settings = {
    gopls = {
      hints = {
        parameterNames = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        rangeVariableTypes = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
})

--------------------------------------------------------------------------------
-- Web
--------------------------------------------------------------------------------
local ts_preferences = {
  importModuleSpecifier = "relative", -- MERN convention: relative imports inside the project
  includePackageJsonAutoImports = "auto",
  quoteStyle = "single",
  jsxAttributeCompletionStyle = "auto",
}
local ts_suggest = { autoImports = true, completeFunctionCalls = true }

vim.lsp.config("ts_ls", {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      },
      suggest = ts_suggest,
      preferences = ts_preferences,
      updateImportsOnFileMove = { enabled = "always" },
    },
    javascript = {
      suggest = ts_suggest,
      preferences = ts_preferences,
      updateImportsOnFileMove = { enabled = "always" },
    },
    completions = { completeFunctionCalls = true },
  },
})

vim.lsp.config("eslint", {
  settings = {
    workingDirectory = { mode = "auto" },
    format = false,
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("tailwindcss", { filetypes = known_filetypes "tailwindcss" })

-- Emmet only in markup/style files: in JS/TS it turns every identifier into a tag
-- abbreviation (`NavBar` → `<NavBar></NavBar>`) and buries ts_ls completions.
vim.lsp.config("emmet_ls", { filetypes = { "html", "css", "scss", "sass", "less", "svelte" } })

--------------------------------------------------------------------------------
-- C / C++
--------------------------------------------------------------------------------
-- query-driver lets clangd ask g++-16 for its include paths (see ~/Library/Preferences/clangd/config.yaml)
vim.lsp.config("clangd", { cmd = { "clangd", "--query-driver=/opt/homebrew/bin/g++-*" } })

--------------------------------------------------------------------------------
-- Markdown / XML
--------------------------------------------------------------------------------
vim.lsp.config("marksman", { filetypes = known_filetypes "marksman" })
vim.lsp.config("lemminx", { filetypes = known_filetypes "lemminx" })

--------------------------------------------------------------------------------
-- Lua (merges with NvChad's lua_ls runtime + library settings)
--------------------------------------------------------------------------------
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

--------------------------------------------------------------------------------
-- Kotlin
--------------------------------------------------------------------------------
vim.lsp.config("kotlin_language_server", {
  settings = {
    kotlin = {
      compiler = { jvm = { target = "17" } },
      completion = { snippets = { enabled = true } },
      inlayHints = { typeHints = true, parameterHints = true, chainingHints = true },
      linting = { debounceTime = 500 },
    },
  },
})

--------------------------------------------------------------------------------
-- Typst
--------------------------------------------------------------------------------
vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "disable", -- conform handles formatting
    exportPdf = "onSave",
    semanticTokens = "enable",
  },
})
