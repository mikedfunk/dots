-- TODO: rewrite without lvim global object
return {
  'lukas-reineke/cmp-rg',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  -- avoid running ripgrep on cwd for things like $HOME for dotfiles, etc. where
  -- it could be expensive
  cond = require 'saatchiart.plugin_configs'.cmp_rg_cond,
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'rg' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'rg' })
  end,
}
