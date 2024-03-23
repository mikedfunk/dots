-- TODO: rewrite without lvim global object
return {
  'ThePrimeagen/refactoring.nvim',
  ft = {
    'golang',
    'java',
    'javascript',
    'javascriptreact',
    'lua',
    'php',
    'python',
    'typescript',
    'typescriptreact',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'folke/which-key.nvim',
    'jose-elias-alvarez/null-ls.nvim',
  },
  init = function()
    lvim.builtin.which_key.vmappings['r'] = {
      name = 'Refactor',
      v = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable', silent = true },
      V = { "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' }, -- doesn't work in php
      e = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", 'Extract Function', silent = true },
      f = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", 'Extract Function to File', silent = true },
      t = { "<Esc><Cmd>lua require 'telescope'.extensions.refactoring.refactors()<CR>", 'Show Refactors' },
    }

    lvim.builtin.which_key.mappings['r'] = {
      name = 'Refactor',
      b = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Block')<CR>", 'Extract Block', silent = true },
      f = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", 'Extract Block to File', silent = true },
    }
  end,
}
