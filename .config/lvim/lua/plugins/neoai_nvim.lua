return {
  'Bryley/neoai.nvim',
  dependencies = { 'MunifTanjim/nui.nvim', 'folke/which-key.nvim' },
  event = 'BufRead',
  -- cmd = {
  --   'NeoAI',
  --   'NeoAIOpen',
  --   'NeoAIClose',
  --   'NeoAIToggle',
  --   'NeoAIContext',
  --   'NeoAIContextOpen',
  --   'NeoAIContextClose',
  --   'NeoAIInject',
  --   'NeoAIInjectCode',
  --   'NeoAIInjectContext',
  --   'NeoAIInjectContextCode',
  -- },
  config = function()
    require 'neoai'.setup {
      models = {
        {
          name = "openai",
          -- model = "gpt-3.5-turbo",
          model = "gpt-4",
          params = nil,
        },
      },
    }

    require 'which-key'.register({
      a = {
        name = 'AI',
        c = { '<Cmd>NeoAIToggle<CR>', 'Chat UI' },
        a = { '<Cmd>NeoAIContext<CR>', 'Context UI' },
      },
    }, { prefix = '<Leader>' })

    require 'which-key'.register({
      a = {
        name = 'AI',
        a = { '<Cmd>NeoAIContext<CR>', 'Context UI' },
      },
    }, { prefix = '<Leader>', mode = 'v' })
  end
}
-- }}}
