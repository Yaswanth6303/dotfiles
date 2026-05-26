-- LSP server-specific configurations
-- Formatting is disabled for all servers (conform.nvim handles formatting)

local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

-- Rust
vim.lsp.config.rust_analyzer = { on_attach = disable_formatting }

-- Go
vim.lsp.config.gopls = {
  on_attach = disable_formatting,
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
}

-- Web — TypeScript / JavaScript (MERN-tuned)
local ts_preferences = {
  importModuleSpecifier = "relative", -- MERN convention: relative imports inside the project
  includePackageJsonAutoImports = "auto",
  quoteStyle = "single",
  jsxAttributeCompletionStyle = "auto",
}
vim.lsp.config.ts_ls = {
  on_attach = disable_formatting,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      },
      suggest = {
        autoImports = true,
        completeFunctionCalls = true,
      },
      preferences = ts_preferences,
      updateImportsOnFileMove = { enabled = "always" },
    },
    javascript = {
      suggest = {
        autoImports = true,
        completeFunctionCalls = true,
      },
      preferences = ts_preferences,
      updateImportsOnFileMove = { enabled = "always" },
    },
    completions = {
      completeFunctionCalls = true,
    },
  },
}

-- ESLint — apply auto-fixes via running LSP (replaces eslint_d in conform)
local eslint_augroup = vim.api.nvim_create_augroup("eslint_fix_on_save", { clear = true })
vim.lsp.config.eslint = {
  on_attach = function(client, bufnr)
    disable_formatting(client)
    -- Clear any previous autocmd on this buffer, then register fresh.
    -- Augroup prevents duplicate autocmds from stacking on LSP re-attach.
    vim.api.nvim_clear_autocmds { group = eslint_augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = eslint_augroup,
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
  end,
  settings = {
    workingDirectory = { mode = "auto" },
    format = false,
  },
}
vim.lsp.config.html = { on_attach = disable_formatting }
vim.lsp.config.jsonls = {
  on_attach = disable_formatting,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
vim.lsp.config.cssls = { on_attach = disable_formatting }
vim.lsp.config.tailwindcss = { on_attach = disable_formatting }

-- Emmet — restricted to markup/style files only.
-- Removed JS/TS/JSX/TSX: emmet treats every identifier as a tag abbreviation
-- (e.g. `NavBar` → `<NavBar></NavBar>`) which buries real LSP component
-- completions. In React you get tag-closing from nvim-ts-autotag, component
-- completion from ts_ls, and snippets from friendly-snippets — no emmet needed.
vim.lsp.config.emmet_ls = {
  on_attach = disable_formatting,
  filetypes = {
    "html",
    "css",
    "scss",
    "sass",
    "less",
    "svelte",
  },
}

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

-- Markdown
vim.lsp.config.marksman = { on_attach = disable_formatting }

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

-- Kotlin
vim.lsp.config.kotlin_language_server = {
  on_attach = disable_formatting,
  settings = {
    kotlin = {
      compiler = {
        jvm = { target = "17" },
      },
      completion = { snippets = { enabled = true } },
      inlayHints = {
        typeHints = true,
        parameterHints = true,
        chainingHints = true,
      },
      linting = { debounceTime = 500 },
    },
  },
}

-- Typst
vim.lsp.config.tinymist = {
  on_attach = disable_formatting,
  settings = {
    formatterMode = "disable", -- conform handles formatting
    exportPdf = "onSave", -- auto-export PDF on save
    semanticTokens = "enable",
  },
}
