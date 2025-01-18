return {
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
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
    "anuvyklack/fold-preview.nvim",
    event = "VeryLazy",
    opts = {
      auto = 400, -- ms before auto open
      border = "rounded",
      default_keybindings = false,
    },
  },
  -- installed by default, this just customizes it
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
        },
        use_libuv_file_watcher = true,
      },
    },
  },
  { "wsdjeg/vim-fetch" }, -- go to file including line number e.g. stack trace
  -- {
  --   "ziontee113/icon-picker.nvim",
  --   dependencies = "stevearc/dressing.nvim",
  --   cmd = { "IconPickerYank", "IconPickerInsert", "IconPickerNormal" },
  --   opts = { disable_legacy_commands = true },
  -- },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true,
        disabledDefaults = { "gc", "gw", "ai", "ii", "aI", "iI" },
      },
    },
  },
  -- { "michaeljsmith/vim-indent-object" },
  { "wurli/visimatch.nvim", event = "VeryLazy", opts = {} },
  { "fpob/nette.vim", event = "VimEnter" },
  { "martinda/Jenkinsfile-vim-syntax", event = "VimEnter" },
  { "aklt/plantuml-syntax", event = "VimEnter" },
  -- { "jwalton512/vim-blade", event = "VimEnter" },
  { "tpope/vim-cucumber", event = "VimEnter" },
  { "neoclide/vim-jsx-improve", ft = { "javascriptreact", "typescriptreact" } },
  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        ini = "# %s",
        sql = "-- %s",
        git_config = "# %s",
      },
    },
  },
  -- added via LazyExtras and customized here to add undotree as an edgy window
  {
    "folke/edgy.nvim",
    opts_extend = { "left" },
    opts = {
      left = {
        { title = "Undotree", ft = "undotree" },
      },
    },
    dependencies = {
      {
        "jiaoshijie/undotree",
        dependencies = {
          "nvim-lua/plenary.nvim",
          {
            "folke/which-key.nvim",
            opts = {
              spec = {
                { "<leader>U", icon = "󱏒" }, -- just to set the icon. Mapping below.
              },
            },
          },
        },
        opts = {},
        keys = {
          {
            "<leader>U",
            function()
              require("undotree").toggle()
            end,
            desc = "Undotree",
          },
        },
      },
    },
  },
}
