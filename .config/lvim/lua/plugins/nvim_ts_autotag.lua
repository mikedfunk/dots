return {
  'windwp/nvim-ts-autotag',
  ft = {
    'html',
    'javascript',
    'javascriptreact',
    'php.html',
    'typescript',
    'typescriptreact',
    'xml',
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  init = function() lvim.builtin.treesitter.autotag.enable = true end,
}
