return {
  {
    "epilande/checkbox-cycle.nvim",
    ft = "markdown",
    opts = { states = { "[ ]", "[x]", "[-]" } },
    keys = {
      { "<CR>", "<Cmd>CheckboxCycleNext<CR>", desc = "Checkbox Next", ft = { "markdown" }, mode = { "n", "v" } },
    },
  },
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "wallpants/github-preview.nvim",
    ft = "markdown",
    cmd = { "GithubPreviewStart", "GithubPreviewToggle", "GithubPreviewStop" },
    keys = {
      { "<Leader>mp", "<Cmd>GithubPreviewToggle<CR>", noremap = true, desc = "Preview Markdown" },
    },
    opts = {},
  },
}
