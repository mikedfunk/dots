local is_installed = require 'mikedfunk.helpers'.is_installed

local pwd = vim.api.nvim_exec('pwd', true)
-- if not pwd:match '/Code/saatchi/.*' then require 'lvim.lsp.manager'.setup 'tsserver' end
if pwd:match '/Code/saatchi/.*' then vim.bo.filetype = 'javascriptreact' end

local should_setup_flow = require 'saatchiart.plugin_configs'.should_setup_flow() and is_installed 'lspconfig'

if should_setup_flow then
  local capabilities = require 'lvim.lsp'.common_capabilities()

  if is_installed('ufo') then
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
  end

  require 'lvim.lsp.manager'.setup('flow', {
    cmd = { 'npx', '--no-install', 'flow-bin@0.126.1', 'lsp', '--lazy-mode=ide' },
    capabilities = capabilities,
  })
end

if is_installed('ufo') then
  -- TODO: neither of these are working
  -- vim.wo.foldlevel = 0
  require 'ufo'.closeFoldsWith(0)
end
