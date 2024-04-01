return {
  "tamago324/nlsp-settings.nvim",
  cmd = "LspSettings",
  lazy = true,
  config = function()
    vim.keymap.set('n', '<leader>lc', '<Cmd>LspSettings buffer<CR>', { noremap = true, desc = 'Configure LSP' })
    vim.keymap.set('n', '<leader>lR', '<Cmd>LspRestart<CR>', { noremap = true, desc = 'Restart LSP' })
  end
}
