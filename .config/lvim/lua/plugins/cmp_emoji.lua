return {
  'hrsh7th/cmp-emoji',
  event = 'InsertEnter',
  dependencies = 'hrsh7th/nvim-cmp',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'emoji' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'emoji' })
  end,
}
