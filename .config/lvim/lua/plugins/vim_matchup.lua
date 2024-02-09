return {
  'andymass/vim-matchup',
  event = 'CursorMoved',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  init = function()
    lvim.builtin.treesitter.matchup.enable = true
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    -- vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
    vim.g.matchup_surround_enabled = 1
  end,
}
