return {
  'wallpants/github-preview.nvim',
  ft = 'markdown',
  keys = {
    { '<Leader>mp', '<Cmd>GithubPreviewToggle<CR>', { noremap = true, desc = "Preview Markdown" } },
  },
  cmd = { 'GithubPreviewStart', 'GithubPreviewToggle', 'GithubPreviewStop' },
  opts = {},
}
