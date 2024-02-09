return {
  'rcarriga/cmp-dap',
  dependencies = {
    'rcarriga/cmp-dap',
    'hrsh7th/nvim-cmp',
  },
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'dap' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'dap' })
  end,
  config = function()
    require 'cmp'.setup.filetype { 'dap-repl', 'dapui_watches' }
  end,
}
