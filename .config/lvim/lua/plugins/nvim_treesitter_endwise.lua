-- TODO: rewrite without lvim global object
return {
  'RRethy/nvim-treesitter-endwise',
  -- event = 'BufRead',
  ft = {
    'ruby',
    'lua',
    'zsh',
    'bash',
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  init = function()
    lvim.builtin.treesitter.endwise = { enable = true }
  end,
}
