return {
  {
    "RRethy/nvim-treesitter-endwise",
    ft = {
      "ruby",
      "lua",
      "zsh",
      "bash",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      endwise = { enable = true },
    },
  },
}
