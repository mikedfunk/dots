---@return nil
local configure_vim_unimpaired = function()
  require 'which-key'.register({
    ['<space>'] = 'Add line below',
    a = 'Next file',
    A = 'Last file',
    -- b = 'Next buffer',
    B = 'Last buffer',
    C = 'String decode',
    e = 'Move line down',
    f = 'Next file in dir',
    l = 'Next in loclist',
    ['<c-l>'] = 'Next in loclist',
    L = 'Last in loclist',
    m = 'Next method start',
    M = 'Next method end',
    -- n = 'Next diff',
    o = 'Disable...',
    p = 'Paste below',
    P = 'Paste below',
    q = 'Next in quickfix',
    ['<c-q>'] = 'Next in quickfix',
    Q = 'Last in quickfix',
    -- t = 'Next tag',
    -- T = 'Last tag',
    u = { name = 'URL decode', u = { name = 'URL decode' } },
    x = { name = 'XML decode', x = { name = 'XML decode' } },
    y = { name = 'String decode', y = { name = 'String decode' } },
    ['<c-t>'] = 'Next preview',
  }, { prefix = ']' })

  require 'which-key'.register({
    ['<space>'] = 'Add line above',
    a = 'Previous file',
    A = 'First file',
    -- b = 'Previous buffer',
    B = 'First buffer',
    C = 'String encode',
    e = 'Move line up',
    f = 'Previous file in dir',
    l = 'Previous in loclist',
    ['<c-l>'] = 'Previous in loclist',
    L = 'First in loclist',
    m = 'Previous method start',
    M = 'Previous method end',
    -- n = 'Previous diff',
    o = 'Enable...',
    p = 'Paste above',
    P = 'Paste above',
    q = 'Previous in quickfix',
    Q = 'First in quickfix',
    ['<c-q>'] = 'Previous in quickfix',
    t = 'Previous tag',
    ['<c-t>'] = 'Previous tag',
    T = 'First tag',
    u = { name = 'URL encode', u = { name = 'URL encode' } },
    x = { name = 'XML encode', x = { name = 'XML encode' } },
    y = { name = 'String encode', y = { name = 'String encode' } },
  }, { prefix = '[' })

  require 'which-key'.register({
    o = { name = 'Toggle...' },
    -- ['<c-g>'] = { name = 'Copy path' },
  }, { prefix = 'y' })
end

return {
  'tpope/vim-unimpaired',
  event = 'BufRead',
  dependencies = 'folke/which-key.nvim',
  config = configure_vim_unimpaired,
}
