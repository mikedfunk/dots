local is_installed = require 'mikedfunk.helpers'.is_installed

local pwd = vim.api.nvim_exec('pwd', true)
-- if not pwd:match '/Code/saatchi/.*' then require 'lvim.lsp.manager'.setup 'tsserver' end
if pwd:match '/Code/saatchi/.*' then vim.bo.filetype = 'javascriptreact' end

local should_setup_flow = require 'saatchiart.plugin_configs'.should_setup_flow() and is_installed 'lspconfig'

if should_setup_flow and not _G.was_flow_setup then
  local capabilities = require 'lvim.lsp'.common_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  require 'lvim.lsp.manager'.setup('flow', {
    cmd = { 'npx', '--no-install', 'flow-bin@0.126.1', 'lsp', '--lazy-mode=ide' },
    capabilities = capabilities,
  })

  require 'ufo'.setup {
    -- provider_selector = function(_, _, _)
    --   return { 'treesitter', 'lsp' }
    -- end,
    close_fold_kinds = {
      -- lsp:
      'comment',
      'imports',
      'region',

      -- treesitter:
      'import_statement',
      'comment',
    }
  }
  require 'ufo'.closeFoldsWith(0)
  _G.was_flow_setup = true
end
