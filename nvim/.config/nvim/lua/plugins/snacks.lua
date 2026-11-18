-- snacks.nvim: prompt boxes (input), notifications (notifier), floating terminal, fuzzy picker,
-- indent guides, images, GitHub (gh), profiler, toggles, LSP-aware renames.
-- Docs: github.com/folke/snacks.nvim/tree/main/docs
-- Picker / gh keymaps live in lua/mappings.lua (they must override NvChad's Telescope maps).

---@module "snacks"

--- <leader>u toggles + profiler toggles. Snacks.toggle needs snacks loaded, so this runs on VeryLazy.
local function setup_toggles()
  local toggle = Snacks.toggle

  toggle.profiler():map "<leader>pp"
  toggle.profiler_highlights():map "<leader>ph"

  toggle.option("spell", { name = "Spelling" }):map "<leader>us"
  toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
  toggle.option("relativenumber", { name = "Relative number" }):map "<leader>uL"
  toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal" })
    :map "<leader>uc"
  toggle.line_number():map "<leader>ul"
  toggle.diagnostics():map "<leader>ud"
  toggle.inlay_hints():map "<leader>uh"
  toggle.treesitter():map "<leader>uT"
  toggle.indent():map "<leader>ug"
  toggle.dim():map "<leader>uD"
  toggle.zen():map "<leader>uz"
  toggle.zoom():map "<leader>uZ"

  -- same flag conform's format_on_save checks (see :FormatToggle in autocmds.lua)
  toggle({
    name = "Format on save",
    get = function()
      return not vim.g.disable_autoformat
    end,
    set = function(state)
      vim.g.disable_autoformat = not state
    end,
  }):map "<leader>uf"
end

--- Renames done in nvim-tree notify the LSP so imports get updated (snacks rename docs).
local function setup_nvim_tree_rename()
  local prev = { new_name = "", old_name = "" } -- nvim-tree can fire the same event twice
  local events = require("nvim-tree.api").events
  events.subscribe(events.Event.NodeRenamed, function(data)
    if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
      prev = data
      Snacks.rename.on_rename_file(data.old_name, data.new_name)
    end
  end)
end

---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      -- vim.ui.input → floating box (nvim-tree create/rename, LSP rename, …)
      input = { enabled = true, icon = "󰏫 " },

      -- vim.notify → stacked boxes in the top-right corner
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact",
        icons = {
          error = "\u{f057} ",
          warn = "\u{f071} ",
          info = "\u{f05a} ",
          debug = "\u{f188} ",
          trace = "\u{f0e7} ",
        },
      },

      -- floating box: <C-/> toggles, q (normal mode) hides, double <Esc> leaves insert mode
      terminal = { enabled = true, win = { position = "float", border = "rounded" } },

      -- fuzzy finder; also replaces vim.ui.select
      picker = {
        enabled = true,
        prompt = "\u{f002}  ",
        ui_select = true,
        sources = {
          files = { hidden = true }, -- include dotfiles, like nvim-tree
          grep = { hidden = true },
        },
      },

      -- indent guides + animated current-scope line (replaces NvChad's indent-blankline)
      indent = { enabled = true, animate = { duration = { step = 15, total = 250 } } },

      -- images in Ghostty/kitty: opens png/jpg/pdf/… and renders images in markdown, html, typst, …
      image = { enabled = true },

      -- GitHub issues & PRs through the `gh` CLI (uses the picker)
      gh = { enabled = true },

      styles = {
        input = { title_pos = "center", border = "rounded" },
        notification = { border = "rounded", wo = { wrap = true } },
        terminal = { title = " \u{f120}  Terminal ", title_pos = "center" },
      },
    },

    keys = {
      -- terminal (<C-_> is what many terminals send for <C-/>)
      {
        "<C-/>",
        function()
          Snacks.terminal()
        end,
        mode = { "n", "t" },
        desc = "\u{f120} Toggle terminal",
      },
      {
        "<C-_>",
        function()
          Snacks.terminal()
        end,
        mode = { "n", "t" },
        desc = "which_key_ignore",
      },

      -- notifications
      {
        "<leader>N",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "󰂚 Notification history",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "󰎟 Dismiss notifications",
      },

      -- files
      {
        "<leader>R",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "󰑕 Rename file (updates imports)",
      },

      -- profiler
      {
        "<leader>ps",
        function()
          Snacks.profiler.scratch()
        end,
        desc = "\u{f0e4} Profiler scratch buffer",
      },
    },

    init = function()
      vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", once = true, callback = setup_toggles })
      vim.api.nvim_create_autocmd("User", { pattern = "NvimTreeSetup", once = true, callback = setup_nvim_tree_rename })
    end,
  },

  -- flutter-tools pulls in dressing.nvim; keep snacks' input/select boxes in Dart files too
  { "stevearc/dressing.nvim", opts = { input = { enabled = false }, select = { enabled = false } } },

  -- snacks.indent draws the guides; two plugins would draw them twice
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
}
