-- noice.nvim: the `:` command line, search, and messages in floating boxes.
-- Notification boxes are drawn by snacks.notifier (noice picks it up automatically).
-- Docs: github.com/folke/noice.nvim
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = {
        view = "cmdline_popup", -- centered box instead of the bottom line
        format = {
          cmdline = { pattern = "^:", icon = "\u{f120}", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "\u{f002} \u{f063}", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "\u{f002} \u{f062}", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "\u{f489}", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "\u{e620}", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
          input = { view = "cmdline_input", icon = "󰥻 " },
        },
      },
      lsp = {
        -- NvChad already handles these; two handlers would fight (see the earlier stuck-signature bug)
        hover = { enabled = false },
        signature = { enabled = false },
        progress = { enabled = false }, -- NvChad's statusline shows LSP progress
      },
      presets = {
        command_palette = true, -- command line and its completion menu together
        long_message_to_split = true, -- long output opens in a split instead of a giant box
        lsp_doc_border = true,
      },
    },
  },
}
