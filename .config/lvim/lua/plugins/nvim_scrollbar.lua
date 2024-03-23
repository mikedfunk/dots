return {
  'petertriho/nvim-scrollbar',
  dependencies = {
    'folke/tokyonight.nvim',
    -- 'nvim-hlslens',
  },
  event = 'VimEnter',
  config = function()
    local is_hlslens_installed, _ = pcall(require, 'hlslens')
    if is_hlslens_installed then require 'scrollbar.handlers.search'.setup() end -- for hlslens. doesn't seem to work :/
    -- local colors = require('tokyonight.colors').setup()

    require('scrollbar').setup({
      handle = {
        highlight = 'PmenuSel',
      },
      -- marks = {
      --   Cursor = { text = "" },
      -- },
      -- marks = {
      --   Search = { color = colors.orange }, -- doesn't seem to work :/
      -- },
      excluded_filetypes = {
        'DressingInput',
        'TelescopePrompt',
      },
    })
  end,
}
