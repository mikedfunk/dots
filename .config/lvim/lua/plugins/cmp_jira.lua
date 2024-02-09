return {
  -- 'lttr/cmp-jira',
  'mikedfunk/cmp-jira', -- fork to use basic auth, which is apparently needed for Jira cloud
  event = 'InsertEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'cmp_jira' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'cmp_jira' })
  end,
  opts = {},
}
