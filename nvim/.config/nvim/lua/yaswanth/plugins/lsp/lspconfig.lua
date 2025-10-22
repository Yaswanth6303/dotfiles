return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
    },
  },

  config = function()
    -- Setup neodev BEFORE lspconfig
    require("neodev").setup({})

    local use_new_api = vim.lsp.config ~= nil
    local lspconfig = not use_new_api and require("lspconfig") or nil
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    -- 🌟 Setup LSP keymaps when LSP attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show diagnostics for file"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show diagnostics for line"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Hover docs"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end,
    })

    -- 🌟 Setup LSP capabilities for cmp
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Unified helper for setting up LSP servers
    local function setup_lsp_server(server_name, config)
      config = config or {}
      config.capabilities = config.capabilities or capabilities

      if use_new_api then
        vim.lsp.config[server_name] = config
      else
        lspconfig[server_name].setup(config)
      end
    end

    -- 🌟 Diagnostics configuration
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
      },
      underline = true,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        format = function(diagnostic)
          local message = diagnostic.message
          if #message > 80 then
            message = message:sub(1, 77) .. "..."
          end
          return message
        end,
      },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        max_width = 100,
        max_height = 20,
      },
      severity_sort = true,
      update_in_insert = false,
    })

    mason_lspconfig.setup({ automatic_installation = true })

    -- Get installed servers
    local installed_servers = mason_lspconfig.get_installed_servers()

    local non_lsp_tools = {
      "stylua",
      "prettier",
      "black",
      "isort",
      "eslint_d",
      "clang-format",
      "goimports",
      "alejandra",
    }

    local function is_language_server(server_name)
      for _, tool in ipairs(non_lsp_tools) do
        if server_name == tool then
          return false
        end
      end
      return true
    end

    local filtered_servers = {}
    for _, server in ipairs(installed_servers) do
      if is_language_server(server) then
        table.insert(filtered_servers, server)
      end
    end

    local servers = #filtered_servers > 0 and filtered_servers
      or {
        "ts_ls",
        "lua_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "clangd",
        "gopls",
        "rust_analyzer",
        "nixd",
      }

    -- 🌟 "Switch-like" dispatch table for server configs
    local server_setups = {
      svelte = function()
        setup_lsp_server("svelte", {
          on_attach = function(client)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,

      graphql = function()
        setup_lsp_server("graphql", {
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,

      emmet_ls = function()
        setup_lsp_server("emmet_ls", {
          filetypes = {
            "html",
            "typescriptreact",
            "javascriptreact",
            "css",
            "sass",
            "scss",
            "less",
            "svelte",
          },
        })
      end,

      lua_ls = function()
        setup_lsp_server("lua_ls", {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end,

      clangd = function()
        setup_lsp_server("clangd", {
          cmd = { "clangd", "--background-index", "--clang-tidy" },
          filetypes = { "c", "cpp", "objc", "objcpp" },
        })
      end,

      gopls = function()
        setup_lsp_server("gopls", {
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
            },
          },
        })
      end,

      rust_analyzer = function()
        setup_lsp_server("rust_analyzer", {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        })
      end,

      ts_ls = function()
        setup_lsp_server("ts_ls", {
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        })
      end,

      nixd = function()
        setup_lsp_server("nixd", {
          settings = {
            nixd = {
              nixpkgs = { expr = "import <nixpkgs> { }" },
              formatting = { command = { "alejandra" } },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/path/to/flake").nixosConfigurations.HOSTNAME.options',
                },
                home_manager = {
                  expr = '(builtins.getFlake "/path/to/flake").homeConfigurations."USER@HOSTNAME".options',
                },
              },
            },
          },
        })
      end,
    }

    -- 🌟 Setup all installed servers using the dispatch table
    for _, server_name in ipairs(servers) do
      local setup_fn = server_setups[server_name]
      if setup_fn then
        setup_fn()
      else
        setup_lsp_server(server_name, {})
      end
    end
  end,
}
