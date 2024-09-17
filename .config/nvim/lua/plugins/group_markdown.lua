return {
  -- Doesn't work (mkdp#install() not found). Just use one that works instead.
  { "iamcco/markdown-preview.nvim", enabled = false },
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
  { "bullets-vim/bullets.vim", event = "VeryLazy", ft = "markdown" },
}
