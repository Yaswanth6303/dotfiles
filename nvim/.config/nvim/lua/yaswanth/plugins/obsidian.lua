return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/Obsidian Vault/nvim/personal",
      },
      -- You can add more workspaces as needed
      -- {
      --   name = "work",
      --   path = "~/work-vault",
      -- },
    },

    -- Optional, completion sources for nvim-cmp
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    -- Optional, configure templates
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    -- Optional, customize note creation
    new_notes_location = "current_dir",
    note_id_func = function(title)
      -- Create note IDs in a way compatible with Obsidian
      local suffix = ""
      if title ~= nil then
        -- If title is given, use it for the ID
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If no title is given, use a timestamp
        suffix = tostring(os.time())
      end
      return suffix
    end,

    -- Optional, configure backlinks and follow links
    follow_url_func = function(url)
      -- Open external URLs with:
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- Linux
    end,

    picker = {
      -- Choose your preferred picker
      name = "telescope",
      -- customize the displayer to show certain fields
      note_displayer = function(note)
        return note.id
      end,
    },

    -- Optional, configure additional filetypes
    note_frontmatter_func = function(note)
      local out = {
        id = note.id,
        tags = note.tags,
        aliases = note.aliases,
        created = os.date("%Y-%m-%d"),
      }
      -- Add more frontmatter fields if you'd like
      return out
    end,

    -- Optional, configure UI elements
    ui = {
      enable = true, -- Enable UI features like the hover preview
    },

    -- Optional, Configure mappings for various commands
    mappings = {
      -- Overrides the 'gf' mapping to navigate to links
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Add additional mappings
      -- Daily notes
      ["<leader>od"] = {
        action = function()
          return require("obsidian").commands.daily_note()
        end,
        opts = { desc = "Create/Open daily note" },
      },
      -- Create a new note
      ["<leader>on"] = {
        action = function()
          return require("obsidian").commands.new_note()
        end,
        opts = { desc = "Create new note" },
      },
      -- Find existing notes
      ["<leader>of"] = {
        action = function()
          return require("obsidian").commands.find_notes()
        end,
        opts = { desc = "Find notes" },
      },
      -- Search within notes
      ["<leader>os"] = {
        action = function()
          return require("obsidian").commands.search_notes()
        end,
        opts = { desc = "Search in notes" },
      },
      -- Open the vault in Obsidian app
      ["<leader>oo"] = {
        action = function()
          return require("obsidian").commands.open_app()
        end,
        opts = { desc = "Open in Obsidian app" },
      },
      -- Follow a link under cursor
      ["<leader>ol"] = {
        action = function()
          return require("obsidian").util.follow_link()
        end,
        opts = { desc = "Follow link" },
      },
      -- Toggle check boxes
      ["<leader>oc"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { desc = "Toggle checkbox" },
      },
      -- Add a link to a note
      ["<leader>oa"] = {
        action = function()
          return require("obsidian").commands.add_link()
        end,
        opts = { desc = "Add link" },
      },
      -- Create backlinks panel
      ["<leader>ob"] = {
        action = function()
          return require("obsidian").commands.backlinks()
        end,
        opts = { desc = "Show backlinks" },
      },
      -- Open today's daily note
      ["<leader>ot"] = {
        action = function()
          return require("obsidian").commands.today()
        end,
        opts = { desc = "Open today's note" },
      },
      -- Open yesterday's daily note
      ["<leader>oy"] = {
        action = function()
          return require("obsidian").commands.yesterday()
        end,
        opts = { desc = "Open yesterday's note" },
      },
      -- Open tomorrow's daily note
      ["<leader>om"] = {
        action = function()
          return require("obsidian").commands.tomorrow()
        end,
        opts = { desc = "Open tomorrow's note" },
      },
      -- Insert template
      ["<leader>oi"] = {
        action = function()
          return require("obsidian").commands.template_insert()
        end,
        opts = { desc = "Insert template" },
      },
      -- Open graph view
      ["<leader>og"] = {
        action = function()
          return require("obsidian").commands.open_graph()
        end,
        opts = { desc = "Open graph view" },
      },
      -- Quick switch between notes
      ["<leader>oq"] = {
        action = function()
          return require("obsidian").commands.quick_switch()
        end,
        opts = { desc = "Quick switch note" },
      },
      -- Rename note
      ["<leader>or"] = {
        action = function()
          return require("obsidian").commands.rename()
        end,
        opts = { desc = "Rename note" },
      },
    },
  },
}
