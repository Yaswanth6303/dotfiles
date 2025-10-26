return {
  "tpope/vim-fugitive",
  config = function()
    -- Set leader key mappings for vim-fugitive
    local map = vim.keymap.set

    -- Git status
    map("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })

    -- Git diff
    map("n", "<leader>gd", ":Gdiffsplit<CR>", { desc = "Git diff" })
    map("n", "<leader>gD", ":Gdiffsplit!<CR>", { desc = "Git diff (vertical)" })

    -- Git commit
    map("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
    map("n", "<leader>gC", ":Git commit --amend<CR>", { desc = "Git commit amend" })

    -- Git push/pull
    map("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
    map("n", "<leader>gP", ":Git pull<CR>", { desc = "Git pull" })

    -- Git log
    map("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
    map("n", "<leader>gL", ":Git log --oneline<CR>", { desc = "Git log oneline" })

    -- Git blame
    map("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })

    -- Git branch
    map("n", "<leader>gB", ":Git branch<CR>", { desc = "Git branch" })

    -- Git add (stage)
    map("n", "<leader>ga", ":Git add %<CR>", { desc = "Git add current file" })
    map("n", "<leader>gA", ":Git add .<CR>", { desc = "Git add all" })

    -- Git restore (unstage)
    map("n", "<leader>gr", ":Git restore --staged %<CR>", { desc = "Git unstage current file" })

    -- Git checkout
    map("n", "<leader>go", ":Git checkout<Space>", { desc = "Git checkout" })

    -- Git merge
    map("n", "<leader>gm", ":Git merge<Space>", { desc = "Git merge" })

    -- Git fetch
    map("n", "<leader>gf", ":Git fetch<CR>", { desc = "Git fetch" })

    -- Git stash
    map("n", "<leader>gS", ":Git stash<CR>", { desc = "Git stash" })
    map("n", "<leader>gSp", ":Git stash pop<CR>", { desc = "Git stash pop" })

    -- Open git in vertical split
    map("n", "<leader>gv", ":vertical Git<CR>", { desc = "Git vertical split" })

    -- Git read (checkout file)
    map("n", "<leader>gR", ":Gread<CR>", { desc = "Git read (checkout file)" })

    -- Git write (stage file)
    map("n", "<leader>gw", ":Gwrite<CR>", { desc = "Git write (stage file)" })
  end,
}
