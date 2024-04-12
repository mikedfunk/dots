return {
  'jayp0521/mason-null-ls.nvim',
  dependencies = {
    'nvimtools/none-ls.nvim',
    'williamboman/mason.nvim',
  },
  opts = {
    -- automatic_setup = true, -- I use lunarvim's lsp module to do the same thing as this feature.
    automatic_installation = {
      -- which null-ls sources to use default PATH installation for (don't install with Mason)
      exclude = {
        'phpcs',
        'phpcbf',
        'mypy',
        'pycodestyle',
      },
    },
  },
}
