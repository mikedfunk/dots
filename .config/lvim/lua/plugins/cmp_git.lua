-- expects GITHUB_API_TOKEN env var to be set
return {
  'petertriho/cmp-git',
  ft = { 'gitcommit', 'octo', 'markdown' },
  dependencies = {
    'hrsh7th/nvim-cmp',
    'nvim-lua/plenary.nvim',
  },
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'git' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'git' })
  end,
  opts = { filetypes = { 'gitcommit', 'octo', 'markdown' } },
}
