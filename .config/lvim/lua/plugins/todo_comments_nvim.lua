return {
  'folke/todo-comments.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/which-key.nvim',
  },
  event = 'BufRead',
  opts = {
    -- highlight = {
    --   after = '',
    --   pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlightng (vim regex) https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
    -- },
    -- search = {
    --   pattern = [[\b(KEYWORDS)]], -- ripgrep regex
    -- }
  },
  init = function()
    require 'which-key'.register({ s = { T = { '<Cmd>TodoTelescope<CR>', 'Todos' } } }, { prefix = '<leader>' })
  end
}
