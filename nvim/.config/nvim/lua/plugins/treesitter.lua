-- Treesitter on nvim-treesitter's `main` branch (the rewrite pinned in lazy-lock.json).
-- On `main` there is no `ensure_installed`/`highlight = { enable }`: parsers are installed with
-- require("nvim-treesitter").install(), and highlighting/indent are switched on per FileType.
-- Installing parsers needs the `tree-sitter` CLI (nix/modules/packages.nix) and a C compiler.
-- Docs: github.com/nvim-treesitter/nvim-treesitter/tree/main

local cfg = require "configs.treesitter"

--- Install parsers from configs/treesitter.lua that are missing (async).
local function install_parsers()
  local nts = require "nvim-treesitter"
  local available, installed = {}, {}
  for _, lang in ipairs(nts.get_available()) do
    available[lang] = true
  end
  for _, lang in ipairs(nts.get_installed()) do
    installed[lang] = true
  end
  local missing = vim.tbl_filter(function(lang)
    return available[lang] and not installed[lang]
  end, cfg.languages)
  if #missing == 0 then
    return
  end
  if vim.fn.executable "tree-sitter" == 0 then
    vim.notify(
      "nvim-treesitter: `tree-sitter` CLI not found, can't install: " .. table.concat(missing, ", "),
      vim.log.levels.WARN
    )
    return
  end
  nts.install(missing)
end

--- Start treesitter highlighting + indent for every buffer that has a parser.
local function enable_per_filetype()
  -- .jinja/.j2 templates (FastAPI) are HTML + Jinja: the htmldjango grammar parses both, so tags
  -- highlight and auto-close; the `jinja` grammar alone only understands {% %} / {{ }}
  vim.treesitter.language.register("htmldjango", "jinja")

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
    callback = function(args)
      if pcall(vim.treesitter.start, args.buf) then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

--- Textobject keymaps from configs/treesitter.lua.
local function map_textobjects()
  local select = require "nvim-treesitter-textobjects.select"
  local move = require "nvim-treesitter-textobjects.move"
  for key, obj in pairs(cfg.textobjects.select) do
    vim.keymap.set({ "x", "o" }, key, function()
      select.select_textobject(obj[1], "textobjects")
    end, { desc = obj[2] })
  end
  for method, maps in pairs(cfg.textobjects.move) do
    for key, obj in pairs(maps) do
      vim.keymap.set({ "n", "x", "o" }, key, function()
        move[method](obj[1], "textobjects")
      end, { desc = obj[2] })
    end
  end
end

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- `main` does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      install_parsers()
      enable_per_filetype()
    end,
  },

  -- af/if (function), ac/ic (class), aa/ia (parameter), ab/ib (block), ]f [f ]c [c jumps
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }
      map_textobjects()
    end,
  },

  -- Sticky context header: shows current function/class at top of buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,
      min_window_height = 20,
      multiline_threshold = 1,
      trim_scope = "outer",
    },
  },
}
