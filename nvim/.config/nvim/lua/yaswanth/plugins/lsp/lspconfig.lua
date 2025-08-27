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

        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import mason_lspconfig plugin
        local mason_lspconfig = require("mason-lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

        -- Utility function to detect Java version automatically
        local function detect_java_runtimes()
            local runtimes = {}

            -- Function to get Java version from path
            local function get_java_version(java_path)
                local handle = io.popen(java_path .. "/bin/java -version 2>&1")
                if handle then
                    local result = handle:read("*a")
                    handle:close()

                    -- Extract version number
                    local version = result:match('openjdk version "(%d+)')
                    if not version then
                        version = result:match('java version "1%.(%d+)')
                    end
                    return version and tonumber(version)
                end
                return nil
            end

            -- Check SDKMAN installations
            local sdkman_java_home = os.getenv("JAVA_HOME")
            if sdkman_java_home and vim.fn.isdirectory(sdkman_java_home) == 1 then
                local version = get_java_version(sdkman_java_home)
                if version then
                    table.insert(runtimes, {
                        name = "JavaSE-" .. version,
                        path = sdkman_java_home,
                    })
                end
            end

            -- Check SDKMAN candidates directory
            local home = os.getenv("HOME")
            local sdkman_candidates = home .. "/.sdkman/candidates/java"
            if vim.fn.isdirectory(sdkman_candidates) == 1 then
                local handle = io.popen("ls -1 " .. sdkman_candidates .. " 2>/dev/null")
                if handle then
                    for java_version_dir in handle:lines() do
                        local full_path = sdkman_candidates .. "/" .. java_version_dir
                        if vim.fn.isdirectory(full_path) == 1 then
                            local version = get_java_version(full_path)
                            if version then
                                local name = "JavaSE-" .. version
                                -- Avoid duplicates
                                local exists = false
                                for _, runtime in ipairs(runtimes) do
                                    if runtime.name == name then
                                        exists = true
                                        break
                                    end
                                end
                                if not exists then
                                    table.insert(runtimes, {
                                        name = name,
                                        path = full_path,
                                    })
                                end
                            end
                        end
                    end
                    handle:close()
                end
            end

            -- Fallback to common system locations
            local common_paths = {
                "/usr/lib/jvm/java-21-openjdk",
                "/usr/lib/jvm/java-17-openjdk",
                "/usr/lib/jvm/java-11-openjdk",
                "/usr/lib/jvm/java-8-openjdk",
                "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home",
                "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
                "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home",
            }

            for _, path in ipairs(common_paths) do
                if vim.fn.isdirectory(path) == 1 then
                    local version = get_java_version(path)
                    if version then
                        local name = "JavaSE-" .. version
                        -- Avoid duplicates
                        local exists = false
                        for _, runtime in ipairs(runtimes) do
                            if runtime.name == name then
                                exists = true
                                break
                            end
                        end
                        if not exists then
                            table.insert(runtimes, {
                                name = name,
                                path = path,
                            })
                        end
                    end
                end
            end

            -- If no runtimes found, add current JAVA_HOME as fallback
            if #runtimes == 0 and sdkman_java_home then
                table.insert(runtimes, {
                    name = "JavaSE-21", -- Default assumption
                    path = sdkman_java_home,
                })
            end

            return runtimes
        end

        -- Function to get Java project root directory
        local function get_java_project_root()
            local root_markers = {
                "gradlew",
                "gradlew.bat",
                "mvnw",
                "mvnw.cmd",
                ".git",
                ".gitignore",
                "pom.xml",
                "build.gradle",
                "build.gradle.kts",
                "settings.gradle",
                "settings.gradle.kts",
                ".project",
                ".classpath",
                "src/main/java",
            }

            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

            -- Find root directory
            local root = vim.fs.dirname(vim.fs.find(root_markers, {
                path = current_dir,
                upward = true,
            })[1])

            return root or current_dir
        end

        -- Helper function to safely organize Java imports
        local function organize_java_imports(bufnr)
            bufnr = bufnr or vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = "jdtls" })
            if #clients == 0 then
                return
            end

            -- Use code action for organize imports (more reliable than execute_command)
            vim.lsp.buf.code_action({
                context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                },
                apply = true,
            })
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                -- set keybinds
                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
            end,
        })

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
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
            underline = true, -- Enable underline for diagnostics (squiggly lines)
            virtual_text = {
                spacing = 4,
                source = "if_many",
                prefix = "●",
                -- Enhanced formatting for better readability
                format = function(diagnostic)
                    local max_width = 80
                    local message = diagnostic.message
                    if #message > max_width then
                        message = message:sub(1, max_width - 3) .. "..."
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

        -- Configure individual language servers
        local servers = mason_lspconfig.get_installed_servers()

        -- If no servers are installed yet, setup common ones manually
        servers = #servers > 0 and servers
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
                "jdtls",
            }

        -- Setup all installed servers with default config
        for _, server_name in ipairs(servers) do
            if server_name == "svelte" then
                -- configure svelte server
                lspconfig["svelte"].setup({
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        vim.api.nvim_create_autocmd("BufWritePost", {
                            pattern = { "*.js", "*.ts" },
                            callback = function(ctx)
                                -- Here use ctx.match instead of ctx.file
                                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                            end,
                        })
                    end,
                })
            elseif server_name == "graphql" then
                -- configure graphql language server
                lspconfig["graphql"].setup({
                    capabilities = capabilities,
                    filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
                })
            elseif server_name == "emmet_ls" then
                -- configure emmet language server
                lspconfig["emmet_ls"].setup({
                    capabilities = capabilities,
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
            elseif server_name == "lua_ls" then
                -- configure lua server (with special settings)
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                })
            elseif server_name == "clangd" then
                -- configure C/C++ language server
                lspconfig["clangd"].setup({
                    capabilities = capabilities,
                    cmd = { "clangd", "--background-index", "--clang-tidy" },
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                })
            elseif server_name == "gopls" then
                -- configure Go language server
                lspconfig["gopls"].setup({
                    capabilities = capabilities,
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            staticcheck = true,
                        },
                    },
                })
            elseif server_name == "rust_analyzer" then
                -- configure Rust language server
                lspconfig["rust_analyzer"].setup({
                    capabilities = capabilities,
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                })
            elseif server_name == "jdtls" then
                -- Enhanced Java language server configuration with auto-detection
                local java_runtimes = detect_java_runtimes()

                lspconfig["jdtls"].setup({
                    capabilities = capabilities,

                    -- Dynamic root directory detection
                    root_dir = get_java_project_root,

                    -- Command with better workspace handling
                    cmd = {
                        "jdtls",
                        "--jvm-arg=-Dlog.level=ALL",
                        "-data",
                        vim.fn.expand("~/.cache/jdtls-workspace")
                            .. "/"
                            .. vim.fn.fnamemodify(get_java_project_root(), ":t"),
                    },

                    -- Comprehensive settings for maximum error detection
                    settings = {
                        java = {
                            -- Configuration with detected runtimes
                            configuration = {
                                runtimes = java_runtimes,
                            },

                            -- Enable all error checking and validation
                            compile = {
                                nullAnalysis = {
                                    mode = "automatic",
                                },
                            },

                            -- Enable comprehensive error detection
                            errors = {
                                incompleteClasspath = {
                                    severity = "warning",
                                },
                            },

                            -- Enhanced import and classpath handling
                            project = {
                                referencedLibraries = {
                                    "lib/**/*.jar",
                                    "**/*.jar",
                                    "**/target/dependency/*.jar",
                                    "**/build/libs/*.jar",
                                },
                            },

                            -- Maven settings
                            maven = {
                                downloadSources = true,
                                updateSnapshots = false,
                            },

                            -- Gradle settings
                            gradle = {
                                downloadSources = true,
                            },

                            -- Eclipse settings
                            eclipse = {
                                downloadSources = true,
                            },

                            -- Enhanced completion
                            completion = {
                                favoriteStaticMembers = {
                                    "org.hamcrest.MatcherAssert.assertThat",
                                    "org.hamcrest.Matchers.*",
                                    "org.hamcrest.CoreMatchers.*",
                                    "org.junit.jupiter.api.Assertions.*",
                                    "java.util.Objects.requireNonNull",
                                    "java.util.Objects.requireNonNullElse",
                                    "org.mockito.Mockito.*",
                                    "java.util.stream.Collectors.*",
                                },
                                filteredTypes = {
                                    "com.sun.*",
                                    "java.awt.*",
                                    "jdk.*",
                                    "sun.*",
                                },
                                maxResults = 50,
                                postfix = {
                                    enabled = true,
                                },
                            },

                            -- Code generation settings
                            codeGeneration = {
                                toString = {
                                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                                },
                                hashCodeEquals = {
                                    useJava7Objects = true,
                                },
                                useBlocks = true,
                                generateComments = true,
                            },

                            -- Source management
                            sources = {
                                organizeImports = {
                                    starThreshold = 9999,
                                    staticStarThreshold = 9999,
                                },
                            },

                            -- Formatting
                            format = {
                                enabled = true,
                                settings = {
                                    profile = "GoogleStyle",
                                },
                            },

                            -- Save actions
                            saveActions = {
                                organizeImports = true,
                                cleanUp = true,
                            },

                            -- Enhanced validation
                            validation = {
                                enabled = true,
                            },

                            -- Code lens features
                            implementationsCodeLens = {
                                enabled = true,
                            },
                            referencesCodeLens = {
                                enabled = true,
                            },

                            -- Signature help
                            signatureHelp = {
                                enabled = true,
                                description = {
                                    enabled = true,
                                },
                            },

                            -- Content provider
                            contentProvider = {
                                preferred = "fernflower",
                            },

                            -- Import settings
                            imports = {
                                gradle = {
                                    enabled = true,
                                },
                                maven = {
                                    enabled = true,
                                },
                                includeDecompiledSources = true,
                            },
                        },
                    },

                    -- Enhanced on_attach function for Java-specific features
                    on_attach = function(client, bufnr)
                        -- Enable formatting capabilities
                        client.server_capabilities.documentFormattingProvider = true
                        client.server_capabilities.documentRangeFormattingProvider = true

                        -- Java-specific keymaps
                        local java_opts = { buffer = bufnr, silent = true }

                        -- Organize imports
                        keymap.set("n", "<leader>jo", function()
                            organize_java_imports()
                        end, vim.tbl_extend(
                            "force",
                            java_opts,
                            { desc = "Organize Java imports" }
                        ))

                        -- Clean workspace (restart LSP)
                        keymap.set("n", "<leader>jc", function()
                            vim.cmd("LspRestart jdtls")
                            vim.notify("Java LSP restarted (workspace refreshed)", vim.log.levels.INFO)
                        end, vim.tbl_extend(
                            "force",
                            java_opts,
                            { desc = "Restart Java LSP (refresh workspace)" }
                        ))

                        -- Refresh/reload current file
                        keymap.set("n", "<leader>jr", function()
                            vim.cmd("edit!")
                            vim.notify("File reloaded from disk", vim.log.levels.INFO)
                        end, vim.tbl_extend(
                            "force",
                            java_opts,
                            { desc = "Reload current file from disk" }
                        ))

                        -- Extract variable
                        keymap.set("v", "<leader>jv", function()
                            vim.lsp.buf.code_action({
                                context = {
                                    only = { "refactor.extract.variable" },
                                    diagnostics = {},
                                },
                                apply = true,
                            })
                        end, vim.tbl_extend(
                            "force",
                            java_opts,
                            { desc = "Extract Java variable (visual mode)" }
                        ))

                        -- Extract method
                        keymap.set("v", "<leader>jm", function()
                            vim.lsp.buf.code_action({
                                context = {
                                    only = { "refactor.extract.method" },
                                    diagnostics = {},
                                },
                                apply = true,
                            })
                        end, vim.tbl_extend(
                            "force",
                            java_opts,
                            { desc = "Extract Java method (visual mode)" }
                        ))

                        -- Generate toString
                        keymap.set("n", "<leader>jt", function()
                            vim.lsp.buf.code_action({
                                context = {
                                    diagnostics = {},
                                },
                                apply = true,
                            })
                        end, vim.tbl_extend("force", java_opts, { desc = "Generate toString" }))

                        -- Generate getters and setters
                        keymap.set("n", "<leader>jg", function()
                            vim.lsp.buf.code_action({
                                context = {
                                    diagnostics = {},
                                },
                                apply = true,
                            })
                        end, vim.tbl_extend(
                            "force",
                            java_opts,
                            { desc = "Generate getters/setters" }
                        ))

                        -- Print Java runtime information on attach
                        vim.defer_fn(function()
                            local runtime_info = "Java LSP attached with runtimes:\n"
                            for _, runtime in ipairs(java_runtimes) do
                                runtime_info = runtime_info .. "  - " .. runtime.name .. ": " .. runtime.path .. "\n"
                            end
                            vim.notify(runtime_info, vim.log.levels.INFO)
                        end, 1000)
                    end,

                    -- Initialize options
                    init_options = {
                        bundles = {},
                        workspaceFolders = { get_java_project_root() },
                    },

                    -- Enhanced handlers for better error reporting
                    handlers = {
                        ["language/status"] = function(_, result)
                            if result.type == "Started" then
                                vim.notify("Java Language Server started successfully", vim.log.levels.INFO)
                            elseif result.type == "Error" then
                                vim.notify(
                                    "Java Language Server error: " .. (result.message or "Unknown error"),
                                    vim.log.levels.ERROR
                                )
                            elseif result.type == "ProjectsImported" then
                                vim.notify("Java projects imported successfully", vim.log.levels.INFO)
                            end
                        end,
                        ["workspace/diagnostic"] = function(_, result, ctx)
                            -- Handle workspace diagnostics for better error reporting
                            if result and result.items then
                                vim.diagnostic.set(vim.lsp.diagnostic.get_namespace(ctx.client_id), 0, result.items)
                            end
                        end,
                    },
                })
            elseif server_name == "ts_ls" then
                -- configure TypeScript/JavaScript language server
                lspconfig["ts_ls"].setup({
                    capabilities = capabilities,
                    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
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
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                })
            else
                -- Default configuration for other servers
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end
        end

        -- Java-specific autocmds and enhancements
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function(args)
                local bufnr = args.buf

                -- Enhanced diagnostic configuration for Java
                vim.diagnostic.config({
                    virtual_text = {
                        spacing = 4,
                        source = "if_many",
                        prefix = "●",
                        format = function(diagnostic)
                            local message = diagnostic.message
                            -- Show source for Java diagnostics
                            if diagnostic.source == "jdtls" then
                                return string.format("%s [jdtls]", message)
                            end
                            return message
                        end,
                    },
                    signs = true,
                    underline = true,
                    update_in_insert = false,
                    severity_sort = true,
                }, bufnr)

                -- Auto-organize imports on save
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        organize_java_imports(bufnr)
                    end,
                })
            end,
        })

        -- Enhanced LSP restart command specifically for Java
        vim.api.nvim_create_user_command("JavaLspRestart", function()
            local clients = vim.lsp.get_active_clients({ name = "jdtls" })
            for _, client in ipairs(clients) do
                client.stop()
            end
            vim.defer_fn(function()
                vim.cmd("edit") -- Trigger LSP attach
                vim.notify("Java LSP restarted", vim.log.levels.INFO)
            end, 1000)
        end, { desc = "Restart Java LSP server" })

        -- Debug command for Java LSP diagnostics
        vim.api.nvim_create_user_command("JavaLspInfo", function()
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = "jdtls" })

            if #clients == 0 then
                vim.notify("No Java LSP clients active for current buffer", vim.log.levels.WARN)
                return
            end

            for _, client in ipairs(clients) do
                local info = {
                    "Java LSP Information:",
                    "  Client ID: " .. client.id,
                    "  Root directory: " .. (client.config.root_dir or "Not set"),
                    "  Server capabilities: " .. (client.server_capabilities and "Available" or "Not available"),
                }

                -- Check workspace folders
                if client.workspace_folders then
                    table.insert(info, "  Workspace folders:")
                    for _, folder in ipairs(client.workspace_folders) do
                        table.insert(info, "    - " .. folder.name)
                    end
                end

                -- Check diagnostics
                local diagnostics = vim.diagnostic.get(bufnr)
                table.insert(info, "  Diagnostics count: " .. #diagnostics)

                if #diagnostics > 0 then
                    table.insert(info, "  Diagnostic breakdown:")
                    local counts = { error = 0, warn = 0, info = 0, hint = 0 }
                    for _, diagnostic in ipairs(diagnostics) do
                        if diagnostic.severity == vim.diagnostic.severity.ERROR then
                            counts.error = counts.error + 1
                        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                            counts.warn = counts.warn + 1
                        elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                            counts.info = counts.info + 1
                        elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                            counts.hint = counts.hint + 1
                        end
                    end
                    table.insert(info, "    Errors: " .. counts.error)
                    table.insert(info, "    Warnings: " .. counts.warn)
                    table.insert(info, "    Info: " .. counts.info)
                    table.insert(info, "    Hints: " .. counts.hint)
                end

                -- Check Java runtimes
                local runtimes = detect_java_runtimes()
                if #runtimes > 0 then
                    table.insert(info, "  Detected Java runtimes:")
                    for _, runtime in ipairs(runtimes) do
                        table.insert(info, "    - " .. runtime.name .. ": " .. runtime.path)
                    end
                end

                vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
            end
        end, { desc = "Show Java LSP information and diagnostics" })

        -- Auto-attach LSP to Java files if not attached
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.java",
            callback = function()
                local bufnr = vim.api.nvim_get_current_buf()

                vim.defer_fn(function()
                    local clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = "jdtls" })
                    if #clients == 0 then
                        vim.notify("Java LSP not attached. Attempting to start...", vim.log.levels.WARN)
                        -- Trigger LSP start
                        vim.cmd("LspStart jdtls")
                    end
                end, 2000)
            end,
        })
    end,
}
