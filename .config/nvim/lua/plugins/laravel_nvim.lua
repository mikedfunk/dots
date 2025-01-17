return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "tpope/vim-dotenv",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "kevinhwang91/promise-async",
    },
    ft = { "php" },
    opts = {
      lsp_server = "intelephense",
      features = {
        model_info = { enable = false },
        override = { enable = false },
        pickers = { enable = false },
      },
    },
  },
}
