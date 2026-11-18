return {
  -- Browser-based live preview
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown: Browser preview" },
    },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 1
    end,
  },

  -- In-buffer rendered markdown (headings, code blocks, tables)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: Toggle in-buffer render" },
    },
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  -- Floating terminal preview with Glow
  {
    "ellisonleao/glow.nvim",
    keys = {
      { "<leader>mg", "<cmd>Glow<cr>", desc = "Markdown: Glow floating preview" },
    },
    cmd = "Glow",
    opts = {},
  },
}
