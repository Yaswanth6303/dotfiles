return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
        "williamboman/mason.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- Function to setup JDTLS for each Java buffer
        local function setup_jdtls()
            local jdtls_ok, jdtls = pcall(require, "jdtls")
            if not jdtls_ok then
                vim.notify("nvim-jdtls plugin not found", vim.log.levels.ERROR)
                return
            end
            
            -- Get JDTLS installation path via Mason
            local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
            
            -- Check if jdtls is installed
            if vim.fn.isdirectory(mason_path) == 0 then
                vim.notify("JDTLS is not installed. Please run :MasonInstall jdtls", vim.log.levels.ERROR)
                return
            end
            
            local jdtls_path = mason_path
            
            -- Determine OS-specific config directory
            local os_config = "config_mac"
            if vim.fn.has("mac") == 1 then
                local uname = vim.fn.system("uname -m"):gsub("\n", "")
                os_config = uname:match("arm64") and "config_mac_arm" or "config_mac"
            elseif vim.fn.has("linux") == 1 then
                local uname = vim.fn.system("uname -m"):gsub("\n", "")
                os_config = uname:match("aarch64") and "config_linux_arm" or "config_linux"
            elseif vim.fn.has("win32") == 1 then
                os_config = "config_win"
            end
            
            local config_dir = jdtls_path .. "/" .. os_config
            local plugins_dir = jdtls_path .. "/plugins"
            local launcher_jar = vim.fn.glob(plugins_dir .. "/org.eclipse.equinox.launcher_*.jar")
            
            if launcher_jar == "" then
                vim.notify("Could not find Eclipse launcher jar", vim.log.levels.ERROR)
                return
            end
            
            -- Workspace directory (per project)
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name
            
            -- Setup capabilities
            local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            if cmp_nvim_lsp_ok then
                capabilities = cmp_nvim_lsp.default_capabilities()
            end
            
            -- JVM arguments
            local jvm_args = {
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms1g",
                "-Xmx2G",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",
            }
            
            local config = {
                cmd = vim.list_extend(
                    { "java" },
                    vim.list_extend(jvm_args, {
                        "-jar", launcher_jar,
                        "-configuration", config_dir,
                        "-data", workspace_dir,
                    })
                ),
                
                capabilities = capabilities,
                
                -- Find project root
                root_dir = require("jdtls.setup").find_root({
                    ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project"
                }),
                
                settings = {
                    java = {
                        eclipse = {
                            downloadSources = true,
                        },
                        configuration = {
                            updateBuildConfiguration = "interactive",
                            runtimes = {}
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
                        format = {
                            enabled = true,
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
                            importOrder = {
                                "java",
                                "javax",
                                "com",
                                "org"
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
                },
                
                init_options = {
                    bundles = {},
                    extendedClientCapabilities = jdtls.extendedClientCapabilities,
                },
                
                on_attach = function(client, bufnr)
                    -- Standard LSP keymaps
                    local opts = { buffer = bufnr, silent = true }
                    
                    -- LSP keybindings
                    vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", 
                        vim.tbl_extend('force', opts, { desc = "Show LSP references" }))
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, 
                        vim.tbl_extend('force', opts, { desc = "Go to declaration" }))
                    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", 
                        vim.tbl_extend('force', opts, { desc = "Show LSP definitions" }))
                    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", 
                        vim.tbl_extend('force', opts, { desc = "Show LSP implementations" }))
                    vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", 
                        vim.tbl_extend('force', opts, { desc = "Show LSP type definitions" }))
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, 
                        vim.tbl_extend('force', opts, { desc = "See available code actions" }))
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, 
                        vim.tbl_extend('force', opts, { desc = "Smart rename" }))
                    vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", 
                        vim.tbl_extend('force', opts, { desc = "Show buffer diagnostics" }))
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, 
                        vim.tbl_extend('force', opts, { desc = "Show line diagnostics" }))
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, 
                        vim.tbl_extend('force', opts, { desc = "Go to previous diagnostic" }))
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, 
                        vim.tbl_extend('force', opts, { desc = "Go to next diagnostic" }))
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, 
                        vim.tbl_extend('force', opts, { desc = "Show documentation for what is under cursor" }))
                    vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", 
                        vim.tbl_extend('force', opts, { desc = "Restart LSP" }))
                    
                    -- Java-specific keybindings
                    vim.keymap.set('n', '<leader>jo', function() jdtls.organize_imports() end, 
                        vim.tbl_extend('force', opts, { desc = 'Organize Imports' }))
                    vim.keymap.set('n', '<leader>jv', function() jdtls.extract_variable() end, 
                        vim.tbl_extend('force', opts, { desc = 'Extract Variable' }))
                    vim.keymap.set('v', '<leader>jv', function() jdtls.extract_variable(true) end, 
                        vim.tbl_extend('force', opts, { desc = 'Extract Variable (Visual)' }))
                    vim.keymap.set('n', '<leader>jc', function() jdtls.extract_constant() end, 
                        vim.tbl_extend('force', opts, { desc = 'Extract Constant' }))
                    vim.keymap.set('v', '<leader>jc', function() jdtls.extract_constant(true) end, 
                        vim.tbl_extend('force', opts, { desc = 'Extract Constant (Visual)' }))
                    vim.keymap.set('v', '<leader>jm', function() jdtls.extract_method(true) end, 
                        vim.tbl_extend('force', opts, { desc = 'Extract Method' }))
                    
                    -- Test commands
                    vim.keymap.set('n', '<leader>tc', function() jdtls.test_class() end, 
                        vim.tbl_extend('force', opts, { desc = 'Test Class' }))
                    vim.keymap.set('n', '<leader>tm', function() jdtls.test_nearest_method() end, 
                        vim.tbl_extend('force', opts, { desc = 'Test Method' }))
                    
                    vim.notify("JDTLS attached successfully", vim.log.levels.INFO)
                end,
            }
            
            -- Start JDTLS
            jdtls.start_or_attach(config)
        end
        
        -- Setup autocommand to start JDTLS for Java files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = setup_jdtls,
            group = vim.api.nvim_create_augroup("JdtlsSetup", { clear = true }),
        })
    end,
}
