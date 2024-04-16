return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "RRethy/nvim-treesitter-endwise", ft = { "ruby", "lua", "zsh", "bash" } },
    { "yioneko/nvim-yati", version = "*" },
    { "gbprod/php-enhanced-treesitter.nvim", ft = { "php" } },
  },
  opts = function(_, _)
    require("nvim-treesitter.configs").setup({
      endwise = { enable = true },
      yati = { enable = true },
      indent = { enable = false }, -- use yati instead
    })
  end,
}
