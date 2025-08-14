-- neogit.lua

return {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration
        "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
        local neogit = require("neogit")

        neogit.setup()

        -- Basic operations
        vim.keymap.set("n", "<leader>ngg", function()
            neogit.open()
        end, { desc = "Neogit: Open status" })

        vim.keymap.set("n", "<leader>ngc", function()
            neogit.open({ "commit" })
        end, { desc = "Neogit: Commit" })

        vim.keymap.set("n", "<leader>ngp", function()
            neogit.open({ "pull" })
        end, { desc = "Neogit: Pull" })

        vim.keymap.set("n", "<leader>ngP", function()
            neogit.open({ "push" })
        end, { desc = "Neogit: Push" })

        -- Branch operations
        vim.keymap.set("n", "<leader>ngb", function()
            neogit.open({ "branch" })
        end, { desc = "Neogit: Branch list" })

        vim.keymap.set("n", "<leader>ngB", function()
            neogit.open({ "branch", "create" })
        end, { desc = "Neogit: Create branch" })

        vim.keymap.set("n", "<leader>ngco", function()
            neogit.open({ "checkout" })
        end, { desc = "Neogit: Checkout branch" })

        -- Log operations
        vim.keymap.set("n", "<leader>ngl", function()
            neogit.open({ "log" })
        end, { desc = "Neogit: Log" })

        vim.keymap.set("n", "<leader>ngL", function()
            neogit.open({ "log", "current" })
        end, { desc = "Neogit: Log current file" })

        -- Stash operations
        vim.keymap.set("n", "<leader>ngs", function()
            neogit.open({ "stash" })
        end, { desc = "Neogit: Stash list" })

        vim.keymap.set("n", "<leader>ngS", function()
            neogit.open({ "stash", "push" })
        end, { desc = "Neogit: Stash push" })

        vim.keymap.set("n", "<leader>ngsp", function()
            neogit.open({ "stash", "pop" })
        end, { desc = "Neogit: Stash pop" })

        -- Rebase operations
        vim.keymap.set("n", "<leader>ngr", function()
            neogit.open({ "rebase" })
        end, { desc = "Neogit: Rebase" })

        vim.keymap.set("n", "<leader>ngri", function()
            neogit.open({ "rebase", "interactive" })
        end, { desc = "Neogit: Interactive rebase" })

        -- Fetch operations
        vim.keymap.set("n", "<leader>ngf", function()
            neogit.open({ "fetch" })
        end, { desc = "Neogit: Fetch" })

        vim.keymap.set("n", "<leader>ngF", function()
            neogit.open({ "fetch", "all" })
        end, { desc = "Neogit: Fetch all" })

        -- Merge operations
        vim.keymap.set("n", "<leader>ngm", function()
            neogit.open({ "merge" })
        end, { desc = "Neogit: Merge" })

        -- Diff operations
        vim.keymap.set("n", "<leader>ngd", function()
            neogit.open({ "diff" })
        end, { desc = "Neogit: Diff" })

        vim.keymap.set("n", "<leader>ngD", function()
            neogit.open({ "diff", "staged" })
        end, { desc = "Neogit: Diff staged" })

        -- Reset operations
        vim.keymap.set("n", "<leader>ngR", function()
            neogit.open({ "reset" })
        end, { desc = "Neogit: Reset" })

        -- Popups for specific operations
        vim.keymap.set("n", "<leader>ng.", function()
            neogit.popup("commit")
        end, { desc = "Neogit: Commit popup" })

        vim.keymap.set("n", "<leader>ng/", function()
            neogit.popup("log")
        end, { desc = "Neogit: Log popup" })

        vim.keymap.set("n", "<leader>ng?", function()
            neogit.popup("help")
        end, { desc = "Neogit: Help popup" })

        -- Quick commit with message
        vim.keymap.set("n", "<leader>ngcm", function()
            vim.ui.input({ prompt = "Commit message: " }, function(msg)
                if msg then
                    vim.cmd('silent !git commit -m "' .. msg .. '"')
                    vim.cmd('echo "Committed: ' .. msg .. '"')
                end
            end)
        end, { desc = "Neogit: Quick commit with message" })

        -- Toggle blame mode for current file
        vim.keymap.set("n", "<leader>ngbl", function()
            if vim.b.neogit_blame_enabled then
                require("neogit").action("toggle_blame")
                vim.b.neogit_blame_enabled = false
                print("Git blame disabled")
            else
                require("neogit").action("toggle_blame")
                vim.b.neogit_blame_enabled = true
                print("Git blame enabled")
            end
        end, { desc = "Neogit: Toggle blame" })
    end,
}
