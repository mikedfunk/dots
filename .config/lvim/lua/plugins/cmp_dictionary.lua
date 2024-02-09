return {
  'uga-rosa/cmp-dictionary',
  dependencies = { 'hrsh7th/nvim-cmp' },
  event = 'InsertEnter',
  init = function()
    local source = { name = 'dictionary', keyword_length = 2, max_item_count = 3 }
    if vim.tbl_contains(lvim.builtin.cmp.sources, source) then return end
    table.insert(lvim.builtin.cmp.sources, source)
  end,
  config = function()
    require 'cmp_dictionary'.setup { dic = { ['*'] = '/usr/share/dict/words' } }
  end,
}
