return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        -- Setup formatters for different languages
        null_ls.setup({
            sources = {
                -- Web development
                null_ls.builtins.formatting.prettier.with({
                    filetypes = {
                        "javascript",
                        "typescript",
                        "css",
                        "html",
                        "json",
                        "markdown",
                        "yaml",
                        "javascriptreact",
                        "typescriptreact",
                    },
                }),
                -- Lua (stylua installed via Nix)
                null_ls.builtins.formatting.stylua,
                -- Python
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                -- Java - use google-java-format
                null_ls.builtins.formatting.google_java_format.with({
                    filetypes = { "java" },
                    extra_args = { "--aosp" }, -- Use AOSP style (4-space indents) or remove for 2-space
                }),
                -- C/C++
                null_ls.builtins.formatting.clang_format.with({
                    filetypes = { "c", "cpp" },
                }),
                -- Go (goimports includes gofmt)
                null_ls.builtins.formatting.goimports,
                -- Nix - use alejandra formatter
                null_ls.builtins.formatting.alejandra.with({
                    filetypes = { "nix" },
                }),
                -- Rust (handled by rust-analyzer LSP)
            },
        })

        -- Enhanced autoformat on save with better error handling
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                local filetype = vim.bo[bufnr].filetype

                -- Skip formatting for certain filetypes or large files
                if vim.tbl_contains({ "oil", "", "txt", "log", "gitcommit", "gitrebase", "help", "man", "qf" }, filetype) then
                    return
                end
                
                -- Only format if we have formatters configured for this filetype
                local supported_filetypes = {
                    "javascript", "typescript", "css", "html", "json", "markdown", "yaml",
                    "javascriptreact", "typescriptreact", "lua", "python", "java", "c", "cpp",
                    "go", "nix", "rust"
                }
                
                if not vim.tbl_contains(supported_filetypes, filetype) then
                    return
                end

                -- Check file size (skip formatting for files larger than 1MB)
                local max_filesize = 1024 * 1024 -- 1 MB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
                if ok and stats and stats.size > max_filesize then
                    return
                end

                -- Format with timeout and error handling
                local format_timeout = 5000 -- 5 seconds
                
                -- Check if any LSP client supports formatting before attempting
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                local has_formatter = false
                
                for _, client in ipairs(clients) do
                    if client.supports_method("textDocument/formatting") then
                        has_formatter = true
                        break
                    end
                end
                
                -- Also check if null-ls has a formatter for this filetype
                local null_ls_ok, null_ls = pcall(require, "null-ls")
                if null_ls_ok and null_ls.is_registered({ method = "formatting", filetype = filetype }) then
                    has_formatter = true
                end
                
                if not has_formatter then
                    return -- Silently skip formatting if no formatter is available
                end

                -- Suppress LSP format error notifications
                local old_notify = vim.notify
                vim.notify = function(msg, level, opts)
                    if type(msg) == "string" and msg:match("Format request failed") then
                        return -- Suppress format failure notifications
                    end
                    old_notify(msg, level, opts)
                end
                
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    async = false,
                    timeout_ms = format_timeout,
                    filter = function(client)
                        -- Prefer null-ls for certain filetypes, LSP for others
                        if filetype == "java" then
                            -- For Java, prefer google-java-format from null-ls over jdtls
                            return client.name == "null-ls"
                        elseif filetype == "go" then
                            -- For Go, prefer goimports from null-ls
                            return client.name == "null-ls" or client.name == "gopls"
                        elseif filetype == "rust" then
                            -- For Rust, prefer rust-analyzer
                            return client.name == "rust_analyzer"
                        elseif filetype == "nix" then
                            -- For Nix, prefer alejandra from null-ls or nixd
                            return client.name == "null-ls" or client.name == "nixd"
                        elseif
                            vim.tbl_contains(
                                { "typescript", "javascript", "typescriptreact", "javascriptreact" },
                                filetype
                            )
                        then
                            -- For JS/TS, prefer prettier from null-ls
                            return client.name == "null-ls"
                        else
                            -- For other languages, use any client that supports formatting
                            return client.supports_method("textDocument/formatting")
                        end
                    end,
                })
                
                -- Restore original notify function
                vim.notify = old_notify
            end,
        })

        -- Optional: Add a command to manually format current buffer
        vim.api.nvim_create_user_command("Format", function()
            vim.lsp.buf.format({
                timeout_ms = 10000,
                async = true,
            })
        end, { desc = "Format current buffer" })

        -- Optional: Add a keymap for manual formatting
        vim.keymap.set("n", "<leader>fi", "<cmd>Format<cr>", { desc = "Format buffer" })
    end,
}
