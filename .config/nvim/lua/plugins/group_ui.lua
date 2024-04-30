return {
  -- {
  --   -- doesn't work. Tmux problem? https://github.com/soulis-1256/eagle.nvim/issues/17
  --   "soulis-1256/eagle.nvim",
  --   branch = "main",
  --   config = true,
  -- },
  { "SmiteshP/nvim-navic", opts = { separator = "  " } },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {},
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
        },
      },
    },
  },
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
      window = { border = "rounded" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      ui = { border = "rounded" },
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
        "alpha",
        "dashboard",
        "lazy",
        "lspinfo",
        "starter",
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
      handlers = { gitsigns = true },
      handle = {
        highlight = "PmenuSel",
      },
      excluded_filetypes = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "lazy",
        "lspinfo",
        "starter",
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
  {
    "kevinhwang91/nvim-bqf",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "qf",
  },
  { "JosefLitos/colorizer.nvim", event = "VeryLazy", config = true },
  { "tzachar/highlight-undo.nvim", event = "VeryLazy", config = true },
  -- { "brenoprata10/nvim-highlight-colors", opts = { enable_tailwind = true } },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ---@type TailwindTools.Option
    opts = {
      document_color = { kind = "background" }, -- or inline
      conceal = { enabled = true },
    },
  },
  {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle", "NeoZoom" },
    keys = {
      { "<C-w>z", "<cmd>NeoZoomToggle<cr>", noremap = true, desc = "Toggle Zoom" },
    },
  },
  {
    -- this expects the extra lazyvim.plugins.extras.ui.mini-animate to be
    -- enabled in lazy.lua. It just tweaks the timing.
    "echasnovski/mini.animate",
    opts = function(_, opts)
      opts.resize.timing = require("mini.animate").gen_timing.cubic({ duration = 75, unit = "total" })
      opts.scroll.timing = require("mini.animate").gen_timing.cubic({ duration = 35, unit = "total" })
    end,
    {
      "nvim-zh/colorful-winsep.nvim",
      event = { "WinNew" },
      config = true,
    },
    {
      "anuvyklack/fold-preview.nvim",
      event = "VeryLazy",
      opts = {
        auto = 400,
        border = "rounded",
        default_keybindings = false,
      },
    },
  },
  {
    "smjonas/live-command.nvim",
    event = "VeryLazy",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
        },
      })
    end,
  },
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        "eldritch-theme/eldritch.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
      },
    },
    opts = {
      options = { theme = "eldritch" },
    },
  },
  {
    "LazyVim/LazyVim",
    dependencies = { "eldritch-theme/eldritch.nvim" },
    opts = { colorscheme = "eldritch" },
  },
}
