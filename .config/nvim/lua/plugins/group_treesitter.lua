return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "gsuuon/tshjkl.nvim", config = true }, -- cool treesitter nav. <m-v> to toggle treesitter nav mode, then just hjkl or HJKL.
    { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "zsh", "bash" } },
    { "gbprod/php-enhanced-treesitter.nvim", ft = { "php" } },
    { "yioneko/nvim-yati", version = "*" },
    {
      "andymass/vim-matchup",
      init = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        -- vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_hi_surround_always = 1
        vim.g.matchup_surround_enabled = 1
      end,
    },
    -- { "yorickpeterse/nvim-tree-pairs", config = true },
  },
  ---@type TSConfig
  opts = {
    auto_install = true,

    -- these are just to make the schema happy
    sync_install = false,
    ignore_install = {},
    modules = {},

    indent = { enable = false }, -- use yati instead
    endwise = { enable = true },
    yati = { enable = true, disable = { "jsx" } },
    matchup = { enable = true },

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
      lsp_interop = {
        enable = true,
        border = "rounded",
        peek_definition_code = {
          ["<leader>pf"] = "@function.outer",
          ["<leader>pc"] = "@class.outer",
        },
      },

      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-select
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          af = "@function.outer",
          ["if"] = "@function.inner",
          ac = "@class.outer",
          ic = "@class.inner",
        },
      },

      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-swap
      swap = {
        enable = true,
        swap_next = { ["g>"] = "@parameter.inner" },
        swap_previous = { ["g<"] = "@parameter.inner" },
      },
      move = { set_jumps = true },
    },
  },
}
