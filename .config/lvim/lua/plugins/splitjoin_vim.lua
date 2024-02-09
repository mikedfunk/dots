local is_installed = require 'helpers'.is_installed

return {
  'AndrewRadev/splitjoin.vim',
  ft = {
    'bash',
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'lua',
    'php',
    'python',
    'ruby',
    'sh',
    'typescript',
    'typescriptreact',
    'zsh',
  },
  branch = 'main',
  dependencies = 'folke/which-key.nvim',
  init = function()
    vim.g['splitjoin_php_method_chain_full'] = 1
    vim.g['splitjoin_quiet'] = 1
    vim.g['splitjoin_trailing_comma'] = require 'saatchiart.plugin_configs'.should_enable_trailing_commas() and 1 or 0
  end,
  config = function()
    if is_installed('which-key') then
      require 'which-key'.register({
        J = { name = 'Join' },
        S = { name = 'Split' },
      }, { prefix = 'g' })
    end
  end,
}
