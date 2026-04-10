return {
  -- Live browser preview for Typst documents
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    build = function()
      require("typst-preview").update()
    end,
    opts = {
      -- Open preview in default browser
      open_cmd = "open %s",
      -- Sync cursor position between editor and preview
      follow_cursor = true,
      -- Dependencies path (uses bundled binary)
      dependencies_bin = { ["tinymist"] = "tinymist" },
    },
  },

  -- Concealment and syntax enhancements for Typst
  {
    "kaarmu/typst.vim",
    ft = "typst",
    init = function()
      -- Enable syntax concealment (renders math symbols, etc.)
      vim.g.typst_conceal = 1
      -- Auto-open PDF after compile
      vim.g.typst_auto_open_quickfix = 0
    end,
  },
}
