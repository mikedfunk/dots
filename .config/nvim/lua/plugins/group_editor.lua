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
  { "nvim-zh/colorful-winsep.nvim", event = "WinNew", opts = {} },
  {
    "wojciech-kulik/filenav.nvim", -- like browser back button for nvim files, not jumps
    event = "VeryLazy",
    opts = {
      next_file_key = "<M-i>",
      prev_file_key = "<M-o>",
    },
  },
  -- { "luukvbaal/statuscol.nvim", opts = {} }, -- clickable fold markers
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
    -- sets commentstring by treesitter lang
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        php = { "// %s", "/* %s */" }, -- doesn't work for some reason
        -- plantuml = "' %s", -- doesn't have a treesitter parser
        -- neon = "# %s", -- doesn't have a treesitter parser
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
  {
    "vuki656/package-info.nvim", -- show available package.json updates
    dependencies = {
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
    },
    event = "BufRead package.json",
    opts = {
      icons = {
        style = {
          up_to_date = "<- ",
          outdated = "<- (new version) ^ ",
        },
      },
    },
    config = function(_, opts)
      require("package-info").setup(opts)

      -- manually register highlight groups due to bug https://github.com/vuki656/package-info.nvim/issues/155#issuecomment-2270572104
      vim.cmd([[highlight PackageInfoUpToDateVersion guifg=]] .. Snacks.util.color("Comment"))
      vim.cmd([[highlight PackageInfoOutdatedVersion guifg=]] .. Snacks.util.color("DiagnosticError"))
    end,
  },
}
