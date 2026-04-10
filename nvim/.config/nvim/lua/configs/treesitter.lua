-- Treesitter: parsers for all languages in use
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
}
