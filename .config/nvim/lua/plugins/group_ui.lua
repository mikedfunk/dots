return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options, {
        persist_buffer_sort = true,
        hover = { enabled = true },
        sort_by = "insert_after_current",
        always_show_bufferline = true,
        style_preset = require("bufferline").style_preset.no_italic,
        separator_style = "slant",
        groups = {
          items = {
            require("bufferline.groups").builtin.pinned:with({ icon = "" }),
          },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        border = "rounded",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      ---@type NoicePresets
      presets = {
        lsp_doc_border = true,
      },
      ---@class NoiceConfigViews
      -- views = {
      --   notify = {
      --     backend = "notify_send",
      --   },
      -- },
      -- https://github.com/folke/noice.nvim/discussions/364
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "snyk",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    ---@type Config
    opts = {
      style = "night",
      lualine_bold = true, -- bold headers for each section header
      day_brightness = 0.15, -- high contrast but colorful
    },
  },
  {
    "cormacrelf/dark-notify",
    config = function()
      require("dark_notify").run({
        onchange = function()
          vim.cmd("silent! !tmux source ~/.config/tmux/tmux.conf &")
        end,
      })
    end,
  },
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {
      ignored_filetypes = {
        "DressingInput",
        "TelescopePrompt",
        "starter",
        "lspinfo",
      },
    },
  },
  {
    "itchyny/vim-highlighturl",
    event = "VeryLazy",
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      handle = {
        highlight = "PmenuSel",
      },
      excluded_filetypes = {
        "DressingInput",
        "TelescopePrompt",
        "starter",
        "lspinfo",
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      {
        "rubiin/fortune.nvim",
        opts = {
          display_format = "mixed",
        },
      },
    },
    opts = {
      config = {
        footer = function()
          return require("fortune").get_fortune()
        end,
      },
    },
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     filesystem = {
  --       -- fucking follow_current_file doesn't work half the time
  --       use_libuv_file_watcher = true,
  --     },
  --   },
  --   keys = {
  --     {
  --       "<leader>e",
  --       -- this reveals more consistently but focuses on the the current file's
  --       -- parent dir :/ Stil doesn't always work.
  --       "<cmd>Neotree reveal %% toggle<cr>",
  --       desc = "Explorer Neotree (reveal)",
  --     },
  --   },
  -- },
}
