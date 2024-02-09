local is_installed = require 'helpers'.is_installed

return {
  'tpope/vim-jdaddy',
  event = 'BufRead',
  config = function()
    if not is_installed('which-key') then return end
    require 'which-key'.register({
      q = { name = 'Format JSON', a = { name = 'Format JSON', j = { name = 'Format JSON' } } },
      w = { name = 'Format JSON', a = { name = 'Format JSON', j = { name = 'Format JSON outer' } } },
    }, { prefix = 'g' })
  end,
}
