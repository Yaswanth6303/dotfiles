return {
  "rcarriga/nvim-notify",
  opts = {
    background_colour = "#1e1e2e",
    fps = 60,
    icons = {
      ERROR = "", -- error icon
      WARN = "", -- warning icon
      INFO = "", -- info icon
      DEBUG = "", -- debug icon
      TRACE = "✎", -- trace icon (optional)
    },
    render = "wrapped-compact", -- clean, minimal style
    stages = "fade_in_slide_out", -- smooth animation
    timeout = 3000,
    top_down = false, -- newest notifications at the bottom
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
