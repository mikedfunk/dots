return {
  'mvllow/modes.nvim',
  event = 'BufRead',
  dependencies = { 'folke/which-key.nvim' },
  init = function()
    -- https://github.com/mvllow/modes.nvim#known-issues
    lvim.builtin.which_key.setup.plugins.presets.operators = false
  end,
  opts = {
    ignored_filetypes = { 'startify' }
  },
}
