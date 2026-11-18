return {
  -- Auto close/rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      aliases = { jinja = "html" }, -- htmlangular / htmldjango are aliased by default
    },
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
      -- `<di` + Enter on a completion → `<div>|</div>` (see configs/tag-complete.lua)
      require("cmp").event:on("confirm_done", require("configs.tag-complete").on_confirm_done)
    end,
  },
}
