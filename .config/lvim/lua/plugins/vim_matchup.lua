return {
  'andymass/vim-matchup',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  -- event = 'CursorMoved',
  ft = {
    'ruby',
    'lua',
    'zsh',
    'bash',
    'php',
    'python',
  }, -- everything but javascript. It's failing there.
  init = function()
    lvim.builtin.treesitter.matchup.enable = true
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    -- vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
    vim.g.matchup_surround_enabled = 1
  end,
}
