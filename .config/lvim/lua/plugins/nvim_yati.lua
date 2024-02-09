return {
  'yioneko/nvim-yati',
  version = '*',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  init = function()
    lvim.builtin.treesitter.yati = { enable = true }
    lvim.builtin.treesitter.indent.enable = false
  end
}
