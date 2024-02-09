return {
  'karb94/neoscroll.nvim',
  dependencies = 'folke/which-key.nvim',
  keys = {
    '<C-u>',
    '<C-d>',
    '<C-f>',
    '<C-b>',
    'zz',
    'zt',
    'zb',
    'gg',
    'G',
  },
  config = function()
    require 'neoscroll'.setup { easing_function = 'cubic' }
    require 'which-key'.register({ g = { 'Go to top of file' } }, { prefix = 'g' })
  end,
}
