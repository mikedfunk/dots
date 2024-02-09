return {
  'nvim-telescope/telescope-dap.nvim',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-telescope/telescope.nvim',
  },
  init = function()
    lvim.builtin.which_key.mappings.d = lvim.builtin.which_key.mappings.d or {}
    lvim.builtin.which_key.mappings.d.l = { function() require 'telescope'.extensions.dap.list_breakpoints {} end, 'List Breakpoints' }
    lvim.builtin.which_key.mappings.d.v = { function() require 'telescope'.extensions.dap.variables {} end, 'Variables' }
    lvim.builtin.which_key.mappings.d.v = { function() require 'telescope'.extensions.dap.frames {} end, 'Call Stack' }
  end,
  config = function() require 'telescope'.load_extension 'dap' end,
}
