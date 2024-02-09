-- TODO: replace, being archived

local is_installed = require 'helpers'.is_installed

return {
  'jose-elias-alvarez/typescript.nvim',
  dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
  -- dependencies = { 'jose-elias-alvarez/null-ls.nvim', 'kevinhwang91/nvim-ufo' },
  ft = {
    -- 'javascript',
    'typescript',
    'typescriptreact',
  },
  config = function()
    local capabilities = require 'lvim.lsp'.common_capabilities()

    if is_installed('ufo') then
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    end

    require 'typescript'.setup {
      server = {
        on_attach = require 'lvim.lsp'.common_on_attach,
        on_init = require 'lvim.lsp'.common_on_init,
        on_exit = require 'lvim.lsp'.common_on_exit,
        capabilities = capabilities,
      }
    }

    require 'null-ls'.register { sources = { require 'typescript.extensions.null-ls.code-actions' } }
  end
}
