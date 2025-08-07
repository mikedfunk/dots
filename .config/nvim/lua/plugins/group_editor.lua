return {
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    },
  },
  { "HawkinsT/pathfinder.nvim", event = "VeryLazy" },
  -- { "tpope/vim-apathy", event = "VeryLazy" },
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
  -- This auto folds stuff in mergetool >:(
  -- {
  --   "chrisgrieser/nvim-origami",
  --   event = "VeryLazy",
  --   opts = {
  --     foldKeymaps = { setup = false },
  --     -- TODO: not working (last checked 2025-04-28)
  --     autoFold = {
  --       enabled = true,
  --       kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
  --     },
  --   },
  -- },
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
        disabledDefaults = { "gc", "gw" },
      },
    },
  },
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
    opts_extend = { "left", "bottom", "right" },
    opts = {
      left = {
        { title = "Undotree", ft = "undotree" },
        { title = "Diffview Files", ft = "DiffviewFiles" },
        -- messes up window: doubles it up. Besides, this is not the only place snacks_picker_list is used.
        -- { title = "Explorer", ft = "snacks_picker_list" },
        -- { title = "Explorer", ft = "snacks_picker_input" },
      },
      right = {
        -- messes up titles, adds ugly padding to bottom
        -- { title = "Avante", ft = "Avante" },
        -- { title = "Avante Selected Files", ft = "AvanteSelectedFiles" },
        -- { title = "Avante Input", ft = "AvanteInput" },
      },
      bottom = {
        { title = "Diffview File History", ft = "DiffviewFileHistory" },
        { title = "QuickFix", ft = "qf" },
      },
      options = {
        left = { size = 40 },
        bottom = { size = 15 },
        right = { size = 40 },
        top = { size = 15 },
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
  -- {
  --   "ethersync/ethersync-nvim",
  --   keys = {
  --     -- { "<leader>j", "<cmd>EthersyncJumpToCursor<cr>" },
  --   },
  --   lazy = false,
  -- },
}
