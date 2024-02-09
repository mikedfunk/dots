return {
  'tsakirist/telescope-lazy.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  init = function()
    lvim.builtin.which_key.mappings.p = lvim.builtin.which_key.mappings.p or {}
    lvim.builtin.which_key.mappings.p.f = { function() vim.cmd('Telescope lazy') end, 'Find' }
  end,
  config = function() require 'telescope'.load_extension 'lazy' end,
}
