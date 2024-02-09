return {
  'tpope/vim-abolish',
  init = function()
    vim.g.abolish_no_mappings = 1
    vim.g.abolish_save_file = vim.env.LUNARVIM_RUNTIME_DIR .. '/after/plugin/abolish.vim'
  end,
  config = function()
    vim.cmd('Abolish colleciton ollection')
    vim.cmd('Abolish connecitno connection')
    vim.cmd('Abolish conneciton connection')
    vim.cmd('Abolish deafult default')
    vim.cmd('Abolish leagcy legacy')
    vim.cmd('Abolish sectino section')
    vim.cmd('Abolish seleciton selection')
    vim.cmd('Abolish striketrough strikethrough')
    vim.cmd('iabbrev shouldREturn shouldReturn')
    vim.cmd('iabbrev willREturn willReturn')
    vim.cmd('iabbrev willTHrow willThrow')
  end
}
