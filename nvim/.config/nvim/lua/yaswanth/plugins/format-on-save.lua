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
                -- Lua
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
                if vim.tbl_contains({ "oil" }, filetype) then
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
