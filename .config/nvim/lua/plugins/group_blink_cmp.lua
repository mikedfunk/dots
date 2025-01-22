return {
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
          "tmux",
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
}
