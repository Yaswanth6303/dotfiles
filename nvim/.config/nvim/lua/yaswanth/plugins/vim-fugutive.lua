return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G" },
  event = "VeryLazy",

  keys = {
    -- 🌿 Git Status / Dashboard
    { "<leader>gs", "<cmd>Git<CR>", desc = "Git Status (Fugitive)" },

    -- 💬 Commit changes
    { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git Commit" },

    -- 📦 Push / Pull
    { "<leader>gp", "<cmd>Git push<CR>", desc = "Git Push" },
    { "<leader>gP", "<cmd>Git pull<CR>", desc = "Git Pull" },

    -- 🔍 Diff and blame
    { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git Diff (split)" },
    { "<leader>gD", "<cmd>Gvdiffsplit<CR>", desc = "Git Diff (vertical)" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },

    -- 🧠 Branch management
    { "<leader>gB", "<cmd>Git branch<CR>", desc = "Git Branches" },
    { "<leader>gC", "<cmd>Git checkout<Space>", desc = "Git Checkout (type branch)" },

    -- 📄 Logs and history
    { "<leader>gl", "<cmd>Git log --oneline --graph --decorate<CR>", desc = "Git Log (simple)" },
    { "<leader>gL", "<cmd>Git log<CR>", desc = "Git Log (full)" },

    -- 🧰 Add / Reset files
    { "<leader>ga", "<cmd>Git add %<CR>", desc = "Git Add current file" },
    { "<leader>gA", "<cmd>Git add .<CR>", desc = "Git Add all" },
    { "<leader>gr", "<cmd>Git restore %<CR>", desc = "Git Restore current file" },
    { "<leader>gR", "<cmd>Git restore .<CR>", desc = "Git Restore all" },

    -- 🔖 Stash
    { "<leader>gsu", "<cmd>Git stash push<CR>", desc = "Git Stash (save changes)" },
    { "<leader>gsp", "<cmd>Git stash pop<CR>", desc = "Git Stash Pop" },
    { "<leader>gsl", "<cmd>Git stash list<CR>", desc = "Git Stash List" },

    -- 🗑️ Remove or clean
    { "<leader>gX", "<cmd>Git clean -xdf<CR>", desc = "Git Clean (remove untracked)" },
  },

  config = function()
    -- Optional: nicer statusline indicator for Fugitive buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "fugitive",
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
    })
  end,
}
