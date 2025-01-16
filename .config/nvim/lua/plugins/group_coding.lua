return {
  -- {
  --   "kylechui/nvim-surround",
  --   version = "*",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- this is installed via LazyExtras and customized here
  {
    "echasnovski/mini.pairs",
    opts = {
      modes = { command = false }, -- do not auto-pair in command or search mode
    },
  },
  {
    "saghen/blink.cmp",
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        -- <c-n>/<c-p> next/prev, <c-y>/<c-e> accept/cancel
        -- This is mostly because if I press enter at the end of a line, by
        -- default it will complete instead of carriage return! This way I
        -- don't have to <esc>o to do that.
        preset = "default", -- lazyvim default is "enter"
      },
      sources = {
        default = {
          "emoji",
          "nerdfont",
          "ripgrep",
          "dictionary",
          "cmp_jira",
        },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            -- score_offset = 15,
            -- min_keyword_length = 2,
            opts = { insert = true }, -- Insert emoji (default) or complete its name
          },
          nerdfont = {
            name = "nerdfont",
            module = "blink.compat.source",
            score_offset = 10,
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            async = true,
            max_items = 5,
            score_offset = -10,
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {},
          },
          dictionary = {
            name = "dictionary",
            module = "blink.compat.source",
            async = true,
            max_items = 5,
            min_keyword_length = 2,
            score_offset = -10,
          },
          tmux = {
            name = "tmux",
            module = "blink.compat.source",
            async = true,
            max_items = 5,
            score_offset = -10,
            opts = {
              all_panes = true,
            },
          },
          cmp_jira = {
            name = "cmp_jira",
            module = "blink.compat.source",
            async = true,
            score_offset = 15,
          },
        },
      },
      completion = {
        documentation = {
          window = {
            border = "rounded",
            winblend = 15,
          },
        },
        menu = {
          draw = { treesitter = { "lsp" } },
          border = "rounded",
          winblend = 15,
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winblend = 15,
        },
      },
    },
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "mikavilpas/blink-ripgrep.nvim",
      {
        "uga-rosa/cmp-dictionary",
        dependencies = { "saghen/blink.compat" },
        opts = {
          paths = { "/usr/share/dict/words" },
        },
      },
      {
        "chrisgrieser/cmp-nerdfont", -- trigger with :nf-
        dependencies = { "saghen/blink.compat" },
      },
      {
        "andersevenrud/cmp-tmux",
        branch = "main",
        dependencies = { "saghen/blink.compat" },
      },
      {
        -- change Jira authentication from oauth to basic auth (API key). Remove debug print.
        "mikedfunk/cmp-jira",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "saghen/blink.compat",
        },
        opts = {},
      },
    },
  },
  {
    "haringsrob/nvim_context_vt",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      prefix = "↩ ",
    },
  },
  { "tpope/vim-apathy", event = "VeryLazy" },
  { "sickill/vim-pasta", event = "BufRead" },
  { "echasnovski/mini.splitjoin", event = "VeryLazy", opts = {} },
  {
    "tpope/vim-projectionist",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = { spec = { { "<leader>A", group = "+alternate" } } },
      },
    },
    lazy = false,
    -- event = "BufRead",
    commands = {
      "A",
      "AV",
      "AS",
      "AT",
    },
    keys = {
      { "<leader>Aa", "<Cmd>A<CR>", noremap = true, desc = "Alternate file" },
      { "<leader>Av", "<Cmd>AV<CR>", noremap = true, desc = "Alternate vsplit" },
      { "<leader>As", "<Cmd>AS<CR>", noremap = true, desc = "Alternate split" },
      { "<leader>At", "<Cmd>AT<CR>", noremap = true, desc = "Alternate tab" },
    },
  },
  {
    "ChrisLetter/cspell-ignore",
    opts = { cspell_path = "./cspell.json" },
    commands = { "CspellIgnore" },
    keys = {
      { "<Leader>ci", "<Cmd>CspellIgnore<CR>", noremap = true, desc = "Cspell Ignore" },
    },
  },
}
