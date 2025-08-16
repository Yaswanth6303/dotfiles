return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()

        -- Setup telescope extension
        local telescope = require("telescope")
        telescope.load_extension("harpoon")

        -- Basic keymaps (avoiding conflicts with your existing setup)
        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "Harpoon add file" })
        vim.keymap.set("n", "<leader>ho", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon open quick menu" })
        vim.keymap.set("n", "<leader>ht", function()
            local current_file = vim.api.nvim_buf_get_name(0)
            local harpoon_list = harpoon:list()

            -- Try multiple path formats to find the file
            local relative_path = vim.fn.fnamemodify(current_file, ":~:.")
            local absolute_path = vim.fn.fnamemodify(current_file, ":p")

            -- Find and remove the current file from the list
            for i, item in ipairs(harpoon_list.items) do
                -- Compare different path formats
                if
                    item.value == current_file
                    or item.value == relative_path
                    or item.value == absolute_path
                    or vim.fn.fnamemodify(item.value, ":p") == absolute_path
                then
                    table.remove(harpoon_list.items, i)
                    vim.notify(
                        "Removed '" .. vim.fn.fnamemodify(current_file, ":t") .. "' from Harpoon",
                        vim.log.levels.INFO
                    )
                    return
                end
            end
            vim.notify("Current file not found in Harpoon list", vim.log.levels.WARN)
        end, { desc = "Harpoon remove current file" })

        -- Telescope integration
        vim.keymap.set("n", "<leader>hf", "<cmd>Telescope harpoon marks<CR>", { desc = "Harpoon telescope view" })

        -- Quick access to first 4 files (using numbers to avoid letter conflicts)
        vim.keymap.set("n", "<leader>h1", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon to file 1" })
        vim.keymap.set("n", "<leader>h2", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon to file 2" })
        vim.keymap.set("n", "<leader>h3", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon to file 3" })
        vim.keymap.set("n", "<leader>h4", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon to file 4" })

        -- Navigate through harpoon list
        vim.keymap.set("n", "<leader>hn", function()
            harpoon:list():next()
        end, { desc = "Harpoon next file" })
        vim.keymap.set("n", "<leader>hp", function()
            harpoon:list():prev()
        end, { desc = "Harpoon prev file" })

        -- Optional: Terminal navigation (if you use terminals in Harpoon)
        -- Uncomment these if you plan to add terminals to your Harpoon list
        -- vim.keymap.set("n", "<leader>ht1", function() harpoon:list():select(1, { type = "terminal" }) end, { desc = "Harpoon terminal 1" })
        -- vim.keymap.set("n", "<leader>ht2", function() harpoon:list():select(2, { type = "terminal" }) end, { desc = "Harpoon terminal 2" })
    end,
}
