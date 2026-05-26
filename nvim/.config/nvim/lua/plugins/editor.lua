return {
  -- Surround: sa (add), sd (delete), sr (replace), sf (find)
  -- Examples: saiw" → surround word with quotes, sd" → delete quotes, sr"' → replace " with '
  {
    "echasnovski/mini.surround",
    keys = {
      { "sa", mode = { "n", "v" }, desc = "Surround: add" },
      { "sd", desc = "Surround: delete" },
      { "sr", desc = "Surround: replace" },
      { "sf", desc = "Surround: find right" },
      { "sF", desc = "Surround: find left" },
      { "sh", desc = "Surround: highlight" },
    },
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        replace = "sr",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        update_n_lines = "sn",
      },
    },
  },

  -- Faster telescope with native fzf sorter (requires make)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "fzf"
    end,
  },
}
