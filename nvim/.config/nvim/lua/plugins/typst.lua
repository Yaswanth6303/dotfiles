return {
  -- Live browser preview for Typst documents
  {
    "chomosuke/typst-preview.nvim",
    keys = {
      { "<leader>Tp", "<cmd>TypstPreviewToggle<cr>", desc = "Typst: Toggle live preview" },
      { "<leader>Ts", "<cmd>TypstPreviewSyncCursor<cr>", desc = "Typst: Sync cursor to preview" },
      {
        "<leader>Tf",
        function()
          local tp = require "typst-preview"
          tp.set_follow_cursor(not tp.get_follow_cursor())
        end,
        desc = "Typst: Toggle follow cursor",
      },
      {
        "<leader>Tw",
        function()
          local file = vim.fn.expand "%:p"
          vim.fn.jobstart({ "typst", "compile", file }, {
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 then
                  vim.notify("Typst: Compiled → " .. file:gsub("%.typ$", ".pdf"), vim.log.levels.INFO)
                else
                  vim.notify("Typst: Compilation failed", vim.log.levels.ERROR)
                end
              end)
            end,
          })
        end,
        desc = "Typst: Compile to PDF",
      },
    },
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
