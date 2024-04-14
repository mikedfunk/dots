return {
  {
    "yioneko/nvim-yati",
    version = "*",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      yati = { enable = true },
      indent = { enable = false }, -- use yati instead
    },
  },
}
