return {
  'tpope/vim-projectionist',
  event = 'BufRead',
  init = function()
    lvim.builtin.which_key.mappings.A = {
      name = 'Alternate',
      a = { '<Cmd>A<CR>', 'Alternate file' },
      v = { '<Cmd>AV<CR>', 'Alternate vsplit' },
      s = { '<Cmd>AS<CR>', 'Alternate split' },
      t = { '<Cmd>AT<CR>', 'Alternate tab' },
    }
  end
}
