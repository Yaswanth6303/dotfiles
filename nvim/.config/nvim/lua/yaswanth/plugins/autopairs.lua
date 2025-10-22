return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
        typescriptreact = { "string", "template_string", "jsx_text" },
        javascriptreact = { "string", "template_string", "jsx_text" },
      },
    })

    -- Make it work with nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- Add JSX/TSX rules
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    autopairs.add_rules({
      -- Auto-close tags like <p> -> <p></p>
      Rule(">", "</", { "typescriptreact", "javascriptreact" }):with_pair(function(opts)
        local line = opts.line
        -- Match <tag>
        local tag = line:match("<(%w+)>$")
        if tag then
          opts.rule.end_pair = "</" .. tag .. ">"
          return true
        end
        return false
      end),

      -- Ensure < gets auto-closed to >
      Rule("<", ">", { "typescriptreact", "javascriptreact" }):with_pair(cond.before_regex("%w")):with_move(),
    })
  end,
}
