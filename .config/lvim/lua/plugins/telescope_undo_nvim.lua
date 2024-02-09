return {
  'debugloop/telescope-undo.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  keys = {
    { '<Leader>u', '<Cmd>Telescope undo<CR>', desc = 'Telescope Undo' },
  },
  init = function()
    lvim.builtin.telescope.extensions.undo = {
      mappings = {
        i = {
          ["<cr>"] = require("telescope-undo.actions").restore,
        },
      },
    }
  end,
  config = function()
    require 'telescope'.load_extension 'undo'
  end,
}
