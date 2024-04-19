return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "zsh", "bash" } },
    { "gbprod/php-enhanced-treesitter.nvim", ft = { "php" } },
    { "yioneko/nvim-yati", version = "*" },
    { "yorickpeterse/nvim-tree-pairs", config = true },
  },
  opts = {
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
  },
}
