return {
  'ray-x/cmp-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp',
  },
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'treesitter' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'treesitter' })
  end,
}
