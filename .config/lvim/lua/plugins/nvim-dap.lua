lvim.builtin.dap.active = true -- nvim-dap
-- require 'dap'.set_log_level('DEBUG') -- debug dap: tail -f ~/.cache/nvim/dap.log

vim.api.nvim_create_augroup('dap_attach', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  group = 'dap_attach',
  callback = function() require 'dap.ext.autocompl'.attach() end,
})

local register_dap_adapters = function()
  local dap = require 'dap'
  dap.adapters.php = {
    type = 'executable',
    command = 'php-debug-adapter', -- this calls the same thing below
    -- command = 'node',
    -- args = { mason_path .. '/packages/php-debug-adapter/extension/out/phpDebug.js' },
  }

  -- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
  dap.adapters['pwa-node'] = {
    -- type = 'executable',
    -- command = 'js-debug-adapter ${port}',
    type = 'server',
    -- host = 'localhost',
    host = '0.0.0.0',
    -- host = '127.0.0.1',
    -- host = '${address}',
    port = 9229,
    -- port = '{port}',
    executable = {
      command = 'js-debug-adapter',
      -- command = mason_path .. '/bin/js-debug-adapter',
      args = { "${port}" },
      -- command = "node",
      -- args = { mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }

  -- dap.adapters.node2 = {
  --   type = 'executable',
  --   command = 'node2-debug-adapter', -- this calls the same thing below
  --   -- command = 'node',
  --   -- args = { mason_path .. '/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  -- }
end

local adjust_dap_signs = function()
  -- vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'debugPC', linehl = 'debugPC', numhl = 'debugPC' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
  -- vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'debugBreakpoint', linehl = 'debugBreakpoint', numhl = 'debugBreakpoint' })
end

local clear_dap_virtual_text = function(_, _)
  local ok, virtual_text = pcall(require, 'nvim-dap-virtual-text.virtual_text')
  if not ok then return end
  virtual_text.clear_virtual_text()
end

local close_dap_ui = function()
  local ok, dapui = pcall(require, 'dapui')
  if not ok then return end
  dapui.close({ reset = true })
end

local register_event_listeners = function()
  require 'dap'.listeners.after['event_terminated']['clear_virtual_text'] = clear_dap_virtual_text
  require 'dap'.listeners.after['event_exited']['clear_virtual_text'] = clear_dap_virtual_text
  require 'dap'.listeners.after['disconnect']['clear_virtual_text'] = clear_dap_virtual_text
  -- require 'dap'.listeners.after['event_stopped']['clear_virtual_text'] = clear_dap_virtual_text

  require 'dap'.listeners.after['event_initialized']['open_dapui'] = function()
    local ok, dapui = pcall(require, 'dapui')
    if not ok then return end
    dapui.open()
  end
  require 'dap'.listeners.after['event_terminated']['close_dapui'] = close_dap_ui
  require 'dap'.listeners.after['event_exited']['close_dapui'] = close_dap_ui
  require 'dap'.listeners.after['disconnect']['close_dapui'] = close_dap_ui
end

lvim.builtin.dap.on_config_done = function()
  register_dap_adapters()
  adjust_dap_signs()
  register_event_listeners()
end

require 'saatchiart.plugin_configs'.configure_nvim_dap()

return {}
