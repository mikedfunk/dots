return {
  'theHamsta/nvim-dap-virtual-text',
  ft = 'php',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    only_first_definition = false,
    all_references = true,
  },
}
