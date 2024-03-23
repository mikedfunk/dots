-- TODO: rewrite without lvim global object
return {
  'CKolkey/ts-node-action',
  event = 'BufRead',
  -- ft = {
  --   'php',
  --   'lua',
  --   'javascript',
  --   'typescript',
  --   'javascriptreact',
  --   'typescriptreact',
  --   'python',
  --   'ruby',
  -- },
  dependencies = 'folke/which-key.nvim',
  config = function()
    -- local padding = {
    --   [','] = '%s ',
    --   ['=>'] = ' %s ',
    --   ['='] = '%s',
    --   ['['] = '%s',
    --   [']'] = '%s',
    --   ['}'] = '%s',
    --   ['{'] = '%s',
    --   ['||'] = ' %s ',
    --   ['&&'] = ' %s ',
    --   ['.'] = ' %s ',
    --   ['+'] = ' %s ',
    --   ['*'] = ' %s ',
    --   ['-'] = ' %s ',
    --   ['/'] = ' %s ',
    -- }
    -- local toggle_multiline = require('ts-node-action.actions.toggle_multiline')(padding)
    require 'ts-node-action'.setup {
      -- php = {
      --   array_creation_expression = toggle_multiline,
      --   formal_parameters = toggle_multiline,
      --   arguments = toggle_multiline,
      --   subscript_expression = toggle_multiline,
      -- }
    }

    require 'lvim.lsp.null-ls.code_actions'.setup {
      { name = 'ts_node_action' },
    }

    -- local is_whichkey_installed, whichkey = pcall(require, 'which-key')
    -- if not is_whichkey_installed then return end
    -- whichkey.register({
    --   J = {
    --     function() require 'ts-node-action'.node_action() end,
    --     'Split/Join'
    --   },
    -- }, { prefix = 'g' })
  end,
}
