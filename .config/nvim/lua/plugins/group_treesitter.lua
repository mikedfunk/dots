return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "zsh", "bash" } },
    { "gbprod/php-enhanced-treesitter.nvim", ft = { "php" } },
    { "yioneko/nvim-yati", version = "*" },
  },
  opts = {
    indent = { enable = false }, -- use yati instead
    endwise = { enable = true },
    yati = { enable = true },
  },
}
