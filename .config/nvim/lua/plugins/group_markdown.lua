return {
  {
    "wallpants/github-preview.nvim",
    dependencies = {
      "folke/which-key.nvim",
      opts = { spec = { { "<leader>m", group = "+markdown" } } },
    },
    ft = "markdown",
    cmd = { "GithubPreviewStart", "GithubPreviewToggle", "GithubPreviewStop" },
    keys = {
      { "<Leader>mp", "<Cmd>GithubPreviewToggle<CR>", buffer = true, noremap = true, desc = "Preview Markdown" },
    },
    opts = {},
  },
  { "bullets-vim/bullets.vim", ft = "markdown" },
}
