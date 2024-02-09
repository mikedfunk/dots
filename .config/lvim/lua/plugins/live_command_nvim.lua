-- preview norm commands with Norm
return {
  'smjonas/live-command.nvim',
  event = 'BufRead',
  config = function ()
    require 'live-command'.setup { commands = { Norm = { cmd = 'norm' } } }
  end
}
