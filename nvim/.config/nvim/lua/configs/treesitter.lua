return {
  ensure_installed = {
    -- Neovim / config
    "vim",
    "vimdoc",
    "lua",
    -- Systems / compiled
    "c",
    "cpp",
    "rust",
    "go",
    "java",
    -- Scripting
    "python",
    "javascript",
    "typescript",
    "tsx",
    "jsx",
    -- Web / data
    "html",
    "css",
    "json",
    "yaml",
    "toml",
    "markdown",
    "graphql",
    "svelte",
    "prisma",
    "sql",
    -- Build / config
    "starlark",
    "groovy",
    "kotlin",
    "xml",
    "properties",
    -- Nix
    "nix",
    -- Dart / Flutter
    "dart",
    -- Typst
    "typst",
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "outer function" },
        ["if"] = { query = "@function.inner", desc = "inner function" },
        ["ac"] = { query = "@class.outer", desc = "outer class" },
        ["ic"] = { query = "@class.inner", desc = "inner class" },
        ["aa"] = { query = "@parameter.outer", desc = "outer parameter" },
        ["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
        ["ab"] = { query = "@block.outer", desc = "outer block" },
        ["ib"] = { query = "@block.inner", desc = "inner block" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = { query = "@function.outer", desc = "Next function start" },
        ["]c"] = { query = "@class.outer", desc = "Next class start" },
      },
      goto_next_end = {
        ["]F"] = { query = "@function.outer", desc = "Next function end" },
        ["]C"] = { query = "@class.outer", desc = "Next class end" },
      },
      goto_previous_start = {
        ["[f"] = { query = "@function.outer", desc = "Prev function start" },
        ["[c"] = { query = "@class.outer", desc = "Prev class start" },
      },
      goto_previous_end = {
        ["[F"] = { query = "@function.outer", desc = "Prev function end" },
        ["[C"] = { query = "@class.outer", desc = "Prev class end" },
      },
    },
  },
}
