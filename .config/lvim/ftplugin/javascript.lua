local pwd = vim.api.nvim_exec('pwd', true)
if not pwd:match '/Code/saatchi/.*' then require 'lvim.lsp.manager'.setup 'tsserver' end

local should_setup_flow = require 'saatchiart.plugin_configs'.should_setup_flow() and is_installed 'lspconfig'

if should_setup_flow then
  require 'lvim.lsp.manager'.setup('flow', {
    cmd = { 'npx', '--no-install', 'flow-bin@0.126.1', 'lsp', '--lazy-mode=ide' }
  })
end
