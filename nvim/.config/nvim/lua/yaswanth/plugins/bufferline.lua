return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "tabs",
      separator_style = "padded_slant",
      diagnostics = "nvim_lsp",
      show_buffer_close_icons = true,
      show_close_icon = true,
      always_show_bufferline = true,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },
      color_icons = true,
    },
    highlights = {
      fill = { bg = "#011423" },
      background = { bg = "#011423", fg = "#627E97" },
      tab = { bg = "#011423", fg = "#627E97" },
      tab_selected = { bg = "#011628", fg = "#CBE0F0", bold = true },

      separator = { fg = "#011423", bg = "#011423" },
      separator_selected = { fg = "#011628", bg = "#011628" },
      separator_visible = { fg = "#011423", bg = "#011423" },

      buffer_selected = {
        bg = "#011628",
        fg = "#CBE0F0",
        bold = true,
        italic = true,
      },
      buffer_visible = { bg = "#011423", fg = "#B4D0E9" },

      -- ✨ Modified files styling ✨
      modified = {
        fg = "#7aa2f7", -- bright blue indicator
        bg = "#011423",
      },
      modified_selected = {
        fg = "#7aa2f7", -- same blue for active
        bg = "#011628",
        bold = true,
        italic = true,
      },
      modified_visible = {
        fg = "#7aa2f7",
        bg = "#011423",
      },

      -- Diagnostics
      error = { fg = "#db4b4b", bg = "#011423" },
      error_selected = { fg = "#db4b4b", bg = "#011628", bold = true },
      warning = { fg = "#FF9E64", bg = "#011423" },
      warning_selected = { fg = "#FF9E64", bg = "#011628", bold = true },
      hint = { fg = "#1abc9c", bg = "#011423" },
      hint_selected = { fg = "#1abc9c", bg = "#011628", bold = true },
    },
  },
}
