-- TODO: rewrite without lvim global object
return {
  'tpope/vim-projectionist',
  event = 'BufRead',
  dependencies = { 'folke/which-key.nvim' },
  init = function()
    require 'which-key'.register({ A = { 'Alternate' } })
    vim.keymap.set('n', '<leader>Aa', '<Cmd>A<CR>', { noremap = true, desc = 'Alternate File' })
    require 'which-key'.register({ Aa = { 'Alternate File' } })
    vim.keymap.set('n', '<leader>Av', '<Cmd>AV<CR>', { noremap = true, desc = 'Alternate Vsplit' })
    require 'which-key'.register({ Av = { 'Alternate Vsplit' } })
    vim.keymap.set('n', '<leader>AS', '<Cmd>AS<CR>', { noremap = true, desc = 'Alternate Split' })
    require 'which-key'.register({ AS = { 'Alternate Split' } })
    vim.keymap.set('n', '<leader>AT', '<Cmd>AT<CR>', { noremap = true, desc = 'Alternate Tab' })
    require 'which-key'.register({ AT = { 'Alternate Tab' } })
  end
}
