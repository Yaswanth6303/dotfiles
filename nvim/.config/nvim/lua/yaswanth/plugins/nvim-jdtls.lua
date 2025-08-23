return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-dap",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        local jdtls = require("jdtls")
        local jdtls_setup = require("jdtls.setup")

        -- Function to get the jdtls config
        local function get_jdtls_config()
            -- Paths - adjust these to match your system
            local home = os.getenv("HOME")
            local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = workspace_path .. project_name

            -- Get platform specific jar path
            local function get_jar_path()
                local mason_registry = require("mason-registry")
                local jdtls_pkg = mason_registry.get_package("jdtls")
                local jdtls_path = jdtls_pkg:get_install_path()

                -- Find the jar file
                local jar_patterns = {
                    jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar",
                }

                for _, pattern in ipairs(jar_patterns) do
                    local jar_files = vim.fn.glob(pattern, true, true)
                    if #jar_files > 0 then
                        return jar_files[1]
                    end
                end
                return nil
            end

            local jar_path = get_jar_path()
            if not jar_path then
                vim.notify("Could not find JDTLS jar file", vim.log.levels.ERROR)
                return nil
            end

            -- Platform specific configuration directory
            local config_dir = function()
                if vim.fn.has("mac") == 1 then
                    return "config_mac"
                elseif vim.fn.has("unix") == 1 then
                    return "config_linux"
                else
                    return "config_win"
                end
            end

            local mason_registry = require("mason-registry")
            local jdtls_pkg = mason_registry.get_package("jdtls")
            local jdtls_path = jdtls_pkg:get_install_path()

            -- Root directory detection
            local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
            local root_dir = jdtls_setup.find_root(root_markers)
            if not root_dir then
                root_dir = vim.fn.getcwd()
            end

            -- Bundles for additional functionality
            local bundles = {}

            -- Add debugger bundle if nvim-dap is available
            local dap_ok, dap = pcall(require, "dap")
            if dap_ok then
                -- Java debug adapter
                local java_debug_adapter = mason_registry.get_package("java-debug-adapter")
                if java_debug_adapter:is_installed() then
                    local java_debug_path = java_debug_adapter:get_install_path()
                    local debug_jar =
                        vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")
                    if debug_jar ~= "" then
                        table.insert(bundles, debug_jar)
                    end
                end

                -- Java test runner
                local java_test = mason_registry.get_package("java-test")
                if java_test:is_installed() then
                    local java_test_path = java_test:get_install_path()
                    local test_jars = vim.fn.glob(java_test_path .. "/extension/server/*.jar", true, true)
                    vim.list_extend(bundles, test_jars)
                end
            end

            local config = {
                cmd = {
                    "java",
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Dlog.protocol=true",
                    "-Dlog.level=ALL",
                    "-Xms1g",
                    "-Xmx2G",
                    "--add-modules=ALL-SYSTEM",
                    "--add-opens",
                    "java.base/java.util=ALL-UNNAMED",
                    "--add-opens",
                    "java.base/java.lang=ALL-UNNAMED",
                    "-jar",
                    jar_path,
                    "-configuration",
                    jdtls_path .. "/" .. config_dir(),
                    "-data",
                    workspace_dir,
                },

                root_dir = root_dir,

                settings = {
                    java = {
                        eclipse = {
                            downloadSources = true,
                        },
                        configuration = {
                            updateBuildConfiguration = "interactive",
                            runtimes = {
                                -- Add your Java runtimes here
                                -- {
                                --   name = "JavaSE-11",
                                --   path = "/usr/lib/jvm/java-11-openjdk/",
                                -- },
                                -- {
                                --   name = "JavaSE-17",
                                --   path = "/usr/lib/jvm/java-17-openjdk/",
                                -- },
                            },
                        },
                        maven = {
                            downloadSources = true,
                        },
                        implementationsCodeLens = {
                            enabled = true,
                        },
                        referencesCodeLens = {
                            enabled = true,
                        },
                        references = {
                            includeDecompiledSources = true,
                        },
                        signatureHelp = { enabled = true },
                        format = {
                            enabled = true,
                            settings = {
                                url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
                                profile = "GoogleStyle",
                            },
                        },
                    },
                    signatureHelp = { enabled = true },
                    completion = {
                        favoriteStaticMembers = {
                            "org.hamcrest.MatcherAssert.assertThat",
                            "org.hamcrest.Matchers.*",
                            "org.hamcrest.CoreMatchers.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "java.util.Objects.requireNonNull",
                            "java.util.Objects.requireNonNullElse",
                            "org.mockito.Mockito.*",
                        },
                        filteredTypes = {
                            "com.sun.*",
                            "io.micrometer.shaded.*",
                            "java.awt.*",
                            "jdk.*",
                            "sun.*",
                        },
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                        },
                        useBlocks = true,
                    },
                },

                init_options = {
                    bundles = bundles,
                },

                capabilities = require("cmp_nvim_lsp").default_capabilities(),

                on_attach = function(client, bufnr)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                    local opts = { noremap = true, silent = true, buffer = bufnr }

                    -- JDTLS specific mappings only (LSP mappings handled by lspconfig.lua)
                    opts.desc = "Organize imports"
                    vim.keymap.set("n", "<leader>co", jdtls.organize_imports, opts)

                    opts.desc = "Extract variable"
                    vim.keymap.set("n", "<leader>cv", jdtls.extract_variable, opts)

                    opts.desc = "Extract constant"
                    vim.keymap.set("n", "<leader>cc", jdtls.extract_constant, opts)

                    opts.desc = "Extract method (visual)"
                    vim.keymap.set("v", "<leader>cm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)

                    opts.desc = "Extract method"
                    vim.keymap.set("n", "<leader>cf", jdtls.extract_method, opts)

                    -- DAP/Testing mappings if available
                    if dap_ok then
                        opts.desc = "Test class"
                        vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts)

                        opts.desc = "Test nearest method"
                        vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, opts)
                    end

                    -- Auto-command for codelens refresh
                    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.codelens.refresh()
                        end,
                    })
                end,
            }

            return config
        end

        -- Auto-command to start JDTLS
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                local config = get_jdtls_config()
                if config then
                    jdtls.start_or_attach(config)
                end
            end,
        })

        -- DAP configuration for Java debugging
        local dap_ok, dap = pcall(require, "dap")
        if dap_ok then
            dap.configurations.java = {
                {
                    type = "java",
                    request = "attach",
                    name = "Debug (Attach) - Remote",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
                {
                    type = "java",
                    request = "launch",
                    name = "Debug (Launch) - Current File",
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
        end
    end,
}
