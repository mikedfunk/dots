return {
  'tpope/vim-projectionist',
  event = 'BufRead',
  init = function()
    lvim.builtin.which_key.mappings.A = { name = 'Alternate' }
    vim.keymap.set('n', '<leader>Aa', '<Cmd>A<CR>', { noremap = true, desc = 'Alternate File' })
    vim.keymap.set('n', '<leader>Av', '<Cmd>AV<CR>', { noremap = true, desc = 'Alternate Vsplit' })
    vim.keymap.set('n', '<leader>AS', '<Cmd>AS<CR>', { noremap = true, desc = 'Alternate Split' })
    vim.keymap.set('n', '<leader>AT', '<Cmd>AT<CR>', { noremap = true, desc = 'Alternate Tab' })
  end
}
