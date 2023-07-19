local is_installed = require 'mikedfunk.helpers'.is_installed

local pwd = vim.api.nvim_exec('pwd', true)
if pwd:match '/Code/saatchi/.*' then vim.bo.filetype = 'javascriptreact' end

local should_setup_flow = require 'saatchiart.plugin_configs'.should_setup_flow() and is_installed 'lspconfig'

if should_setup_flow and not _G.was_flow_setup then
  require 'lvim.lsp.manager'.setup('flow')
  _G.was_flow_setup = true
end

require 'lvim.lsp.manager'.setup('emmet_language_server')
