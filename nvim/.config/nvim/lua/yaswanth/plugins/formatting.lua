return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
                -- Systems programming languages
                c = { "clang-format" },
                cpp = { "clang-format" },
                go = { "goimports" },
                rust = { "rustfmt" },
            },
            -- Configure formatters to use 4-space indentation
            formatters = {
                prettier = {
                    args = {
                        "--stdin-filepath",
                        "$FILENAME",
                        "--tab-width",
                        "4",
                        "--use-tabs",
                        "false",
                        "--single-quote",
                        "true",
                        "--trailing-comma",
                        "es5",
                        "--bracket-spacing",
                        "true",
                        "--bracket-same-line",
                        "false",
                        "--arrow-parens",
                        "avoid",
                        "--end-of-line",
                        "lf",
                        "--print-width",
                        "100",
                    },
                },
            },
            -- Formatters will use their respective config files (.prettierrc.json, .stylua.toml, etc.)
            -- which are already configured for 4-space indentation
            -- Format on save with fallback to auto-indentation
            format_on_save = function(bufnr)
                -- Disable format on save for certain file types where auto-indent is preferred
                local disable_filetypes = { "sql", "json" }
                if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
                    return
                end
                return {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                }
            end,
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
