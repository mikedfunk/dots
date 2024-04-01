return {
  "tamago324/nlsp-settings.nvim",
  config = function()
    vim.keymap.set('n', '<leader>lc', '<Cmd>LspSettings buffer<CR>', { noremap = true, desc = 'Configure LSP' })
    vim.keymap.set('n', '<leader>lR', '<Cmd>LspRestart<CR>', { noremap = true, desc = 'Restart LSP' })
  end
}
