return {
  'ofirgall/goto-breakpoints.nvim',
  dependencies = 'folke/which-key.nvim',
  init = function()
    require 'which-key'.register({
      d = { function() require 'goto-breakpoints'.next() end, 'Go to Next Breakpoint' },
    }, { prefix = ']' })
    require 'which-key'.register({
      d = { function() require 'goto-breakpoints'.next() end, 'Go to Previous Breakpoint' },
    }, { prefix = '[' })
  end
}
