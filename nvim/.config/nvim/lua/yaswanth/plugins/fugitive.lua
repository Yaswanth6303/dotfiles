-- fugitive.vim setup for Neovim using Lua
-- Place this in your init.lua or in a separate file like plugins/fugitive.lua

-- Ensure you have a plugin manager installed. This example uses packer.nvim
-- If you're using a different plugin manager, adjust accordingly

return {
  -- Install fugitive.vim
  {
    "tpope/vim-fugitive",
    -- Optional: lazy-load only when Git commands are used
    -- cmd = {
    --   'Git', 'Gstatus', 'Gcommit', 'Gdiff', 'Gblame', 'Gread', 'Gwrite', 'Gpush', 'Gpull'
    -- },
    config = function()
      -- Key mappings for common fugitive commands
      vim.keymap.set("n", "<Leader>gs", ":Git<CR>", { noremap = true, silent = true, desc = "Git status" })
      vim.keymap.set("n", "<Leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git commit" })
      vim.keymap.set("n", "<Leader>gd", ":Gdiff<CR>", { noremap = true, silent = true, desc = "Git diff" })
      vim.keymap.set("n", "<Leader>gb", ":Git blame<CR>", { noremap = true, silent = true, desc = "Git blame" })
      vim.keymap.set("n", "<Leader>gl", ":Git log<CR>", { noremap = true, silent = true, desc = "Git log" })
      vim.keymap.set("n", "<Leader>gp", ":Git push<CR>", { noremap = true, silent = true, desc = "Git push" })
      vim.keymap.set("n", "<Leader>gpl", ":Git pull<CR>", { noremap = true, silent = true, desc = "Git pull" })

      -- Optional: create a user command to open Git in a split
      vim.api.nvim_create_user_command("Gsplit", function()
        vim.cmd("split | Git")
      end, {})

      -- Optional: additional customization
      -- Auto-close fugitive buffers when you leave them
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "fugitive://*",
        callback = function()
          vim.api.nvim_create_autocmd("BufLeave", {
            buffer = 0,
            callback = function()
              if vim.fn.bufname("%"):match("^fugitive://") then
                vim.cmd("close")
              end
            end,
          })
        end,
      })
    end,
  },
}
