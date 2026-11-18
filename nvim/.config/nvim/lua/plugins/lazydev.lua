-- lazydev.nvim: gives lua_ls the types of Neovim, lazy.nvim and plugins while editing this config,
-- so annotations like `---@type snacks.Config` and globals like `Snacks` resolve.
-- Docs: github.com/folke/lazydev.nvim
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- each entry loads only when one of its `words` appears in the file
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazySpec", "LazyPluginSpec" } },
      },
    },
  },

  -- completion for `require("…")` module names and `---@module` annotations
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "lazydev", group_index = 0 }) -- 0: skip duplicate lua_ls items
    end,
  },
}
