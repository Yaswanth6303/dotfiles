return {
  -- Markdown rendering and preview
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown", -- Set name before main to avoid circular references
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    main = "render-markdown",
    opts = {
      -- Customize the rendering options
      render = {
        -- Set code block style
        code_block = {
          highlight = true,
          theme = "catppuccin", -- Match with your color scheme
        },
        -- Customize heading styles
        heading = {
          underline = true,
          bold = true,
        },
        -- Add nice symbols to lists
        list = {
          indent = "  ",
          marker = "•", -- Optional: change bullet style
        },
      },
    },
  },

  -- Markdown Preview in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_browser = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_port = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
    end,
  },

  -- Vim-pencil for better writing experience
  {
    "preservim/vim-pencil",
    ft = { "markdown", "text" },
    config = function()
      vim.cmd([[
        augroup pencil
          autocmd!
          autocmd FileType markdown,text call pencil#init()
        augroup END
      ]])
      -- Options for pencil
      vim.g["pencil#wrapModeDefault"] = "soft"
      vim.g["pencil#textwidth"] = 80
      vim.g["pencil#joinspaces"] = 0
      vim.g["pencil#cursorwrap"] = 1
      vim.g["pencil#conceallevel"] = 2
      vim.g["pencil#concealcursor"] = "nc"
    end,
  },

  -- Zen mode for distraction-free writing
  {
    "folke/zen-mode.nvim",
    ft = { "markdown", "text" },
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 0.95,
          width = 80,
          height = 0.8,
          options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            list = false,
            colorcolumn = "",
          },
        },
        plugins = {
          options = {
            enabled = true,
            ruler = false,
            showcmd = false,
          },
          twilight = { enabled = true },
          gitsigns = { enabled = false },
          tmux = { enabled = false },
        },
        on_open = function()
          -- Enable soft wrapping
          vim.wo.wrap = true
          vim.wo.linebreak = true
          vim.wo.breakindent = true
        end,
        on_close = function()
          -- Return to your regular settings
          -- Uncomment and customize if you want to restore previous settings
          -- vim.wo.wrap = false
          -- vim.wo.linebreak = false
          -- vim.wo.breakindent = false
        end,
      })

      -- Add keybindings for zen-mode
      vim.api.nvim_set_keymap("n", "<leader>z", ":ZenMode<CR>", { noremap = true, silent = true })
    end,
  },

  -- Twilight for focusing on the current paragraph
  {
    "folke/twilight.nvim",
    ft = { "markdown", "text" },
    config = function()
      require("twilight").setup({
        dimming = {
          alpha = 0.25,
          color = { "Normal", "#ffffff" },
          term_bg = "#000000",
          inactive = false,
        },
        context = 10,
        treesitter = true,
        expand = {
          "function",
          "method",
          "table",
          "if_statement",
        },
        exclude = {},
      })
    end,
  },
}
