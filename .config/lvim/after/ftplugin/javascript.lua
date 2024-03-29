-- local pwd = vim.api.nvim_exec('pwd', true)
-- if pwd:match '/Code/saatchi/.*' then vim.bo.filetype = 'javascriptreact' end

require 'lvim.lsp.manager'.setup('emmet_language_server')

local is_lspconfig_installed, _ = pcall(require, 'lspconfig')
local should_setup_flow = require 'saatchiart.plugin_configs'.should_setup_flow() and is_lspconfig_installed

if not should_setup_flow then
  require 'lvim.lsp.manager'.setup('tsserver')
end

if should_setup_flow and not _G.was_flow_setup then
  -- this is causing problems with treesitter
  -- vim.bo.filetype = 'javascriptreact'
  require 'lvim.lsp.manager'.setup('flow')
  _G.was_flow_setup = true
end
