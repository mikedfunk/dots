return {
  'chrisgrieser/cmp-nerdfont',
  event = 'InsertEnter',
  dependencies = 'hrsh7th/nvim-cmp',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'nerdfont' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'nerdfont' })
  end,
}
