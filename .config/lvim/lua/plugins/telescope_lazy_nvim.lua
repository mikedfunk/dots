-- TODO: rewrite without lvim global object
return {
  'tsakirist/telescope-lazy.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  init = function()
    lvim.builtin.which_key.mappings.p = lvim.builtin.which_key.mappings.p or {}
    vim.keymap.set('n', '<leader>pf', '<Cmd>Telescope lazy<CR>', { noremap = true, desc = 'Find' })
  end,
  config = function() require 'telescope'.load_extension 'lazy' end,
}
