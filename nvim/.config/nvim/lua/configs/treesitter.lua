-- Treesitter data used by plugins/treesitter.lua (nvim-treesitter `main` branch).

return {
  -- parsers to install; names not known to nvim-treesitter are skipped
  languages = {
    -- Neovim / config
    "vim",
    "vimdoc",
    "lua",
    "query",
    -- Systems / compiled
    "c",
    "cpp",
    "rust",
    "go",
    "java",
    -- Scripting
    "python",
    "bash",
    "javascript",
    "typescript",
    "tsx", -- also covers .jsx
    -- Web / data
    "html",
    "angular", -- Angular templates (htmlangular)
    "htmldjango", -- Jinja/Django templates detected as htmldjango
    "jinja",
    "jinja_inline",
    "css",
    "scss",
    "json",
    "yaml",
    "toml",
    "markdown",
    "markdown_inline",
    "graphql",
    "svelte",
    "prisma",
    "sql",
    "regex", -- noice: highlights / search in the command-line box
    -- Build / config
    "starlark",
    "groovy",
    "kotlin",
    "xml",
    "properties",
    "nix",
    "dart",
    -- Docs
    "typst",
    "latex", -- snacks.image renders LaTeX math in markdown
  },

  -- nvim-treesitter-textobjects keymaps: key = { query, description }
  textobjects = {
    -- visual / operator-pending: vaf, dif, cia, …
    select = {
      af = { "@function.outer", "outer function" },
      ["if"] = { "@function.inner", "inner function" },
      ac = { "@class.outer", "outer class" },
      ic = { "@class.inner", "inner class" },
      aa = { "@parameter.outer", "outer parameter" },
      ia = { "@parameter.inner", "inner parameter" },
      ab = { "@block.outer", "outer block" },
      ib = { "@block.inner", "inner block" },
    },
    -- normal / visual / operator-pending jumps
    move = {
      goto_next_start = {
        ["]f"] = { "@function.outer", "Next function start" },
        ["]c"] = { "@class.outer", "Next class start" },
      },
      goto_next_end = {
        ["]F"] = { "@function.outer", "Next function end" },
        ["]C"] = { "@class.outer", "Next class end" },
      },
      goto_previous_start = {
        ["[f"] = { "@function.outer", "Prev function start" },
        ["[c"] = { "@class.outer", "Prev class start" },
      },
      goto_previous_end = {
        ["[F"] = { "@function.outer", "Prev function end" },
        ["[C"] = { "@class.outer", "Prev class end" },
      },
    },
  },
}
