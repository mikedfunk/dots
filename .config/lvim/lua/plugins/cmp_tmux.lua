-- TODO: rewrite without lvim global object
return {
  'andersevenrud/cmp-tmux',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  branch = 'main',
  init = function()
    local source = { name = 'tmux', option = { all_panes = true } }
    if vim.tbl_contains(lvim.builtin.cmp.sources, source) then return end
    table.insert(lvim.builtin.cmp.sources, source)
  end,
}
