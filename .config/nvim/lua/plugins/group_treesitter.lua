return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "zsh", "bash" } },
    { "gbprod/php-enhanced-treesitter.nvim", ft = { "php" } },
    { "yioneko/nvim-yati", version = "*" },
    { "yorickpeterse/nvim-tree-pairs", config = true },
  },
  opts = {
    auto_install = true,

    indent = { enable = false }, -- use yati instead
    endwise = { enable = true },
    yati = { enable = true },

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
