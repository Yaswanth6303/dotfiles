return {
  -- Override NvimTree to show dotfiles and git-ignored files
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
    },
  },
}
