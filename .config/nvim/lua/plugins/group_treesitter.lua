return {
  {
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      -- vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_surround_enabled = 1
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = { matchup = { enable = true } },
      },
    },
  },
  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "ruby", "lua", "vimscript", "zsh", "bash" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = { endwise = { enable = true } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- { "gsuuon/tshjkl.nvim", config = true }, -- cool treesitter nav. <m-v> to toggle treesitter nav mode, then just hjkl or HJKL.
      -- { "gbprod/php-enhanced-treesitter.nvim", ft = { "php" } },
      -- { "yioneko/nvim-yati", version = "*" },
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            {
              "<leader>k",
              group = "+peek",
              icon = "",
            },
          },
        },
      },
      -- { "yorickpeterse/nvim-tree-pairs", config = true },
    },
    opts_extend = {
      "highlight.additional_vim_regex_highlighting",
    },
    opts = {
      auto_install = true,

      -- these are just to make the schema happy
      sync_install = false,
      ignore_install = {},
      modules = {},

      -- indent = { enable = false }, -- use yati instead or just disable it
      -- yati = { enable = true, disable = { "jsx" } },

      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1742
      -- this is misleading: it's to fix indent, not highlighting
      highlight = {
        additional_vim_regex_highlighting = { "php", "jsx" },
      },

      ensure_installed = {
        "comment",
        "lua", -- update to latest
        "luadoc",
        "jsdoc",
        "markdown_inline",
        "phpdoc",
        "regex",
        "sql",
        "vim",
      },

      textobjects = {

        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#textobjects-lsp-interop
        -- lsp_interop = {
        --   enable = true,
        --   border = "rounded",
        --   -- TODO: Can't seem to which-key this
        --   peek_definition_code = {
        --     ["<leader>kf"] = "@function.outer",
        --     ["<leader>kc"] = "@class.outer",
        --   },
        -- },

        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-select
        -- select = {
        --   enable = true,
        --   lookahead = true,
        --   keymaps = {
        --     af = "@function.outer",
        --     ["if"] = "@function.inner",
        --     ac = "@class.outer",
        --     ic = "@class.inner",
        --   },
        -- },

        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-swap
        -- swap = {
        --   enable = true,
        --   -- TODO: Can't seem to which-key this
        --   swap_next = { ["g>"] = "@parameter.inner" },
        --   swap_previous = { ["g<"] = "@parameter.inner" },
        -- },
        move = { set_jumps = true },
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
  -- {
  --   "aaronik/treewalker.nvim",
  --   opts = {},
  --   keys = {
  --     { "<C-k>", "<cmd>Treewalker Up<cr>", { mode = { "n", "v" } } },
  --     { "<C-j>", "<cmd>Treewalker Down<cr>", { mode = { "n", "v" } } },
  --     { "<C-l>", "<cmd>Treewalker Right<cr>", { mode = { "n", "v" } } },
  --     { "<C-h>", "<cmd>Treewalker Left<cr>", { mode = { "n", "v" } } },
  --
  --     -- TODO: not working
  --     -- { "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", { mode = { "n" } } },
  --     -- { "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", { mode = { "n" } } },
  --     -- { "<C-S-l>", "<cmd>Treewalker SwapRight<cr>", { mode = { "n" } } },
  --     -- { "<C-S-h>", "<cmd>Treewalker SwapLeft<cr>", { mode = { "n" } } },
  --   },
  -- },
}
