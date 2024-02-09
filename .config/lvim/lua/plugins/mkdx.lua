local is_installed = require 'helpers'.is_installed

---@return nil
local setup_mkdx = function()
  vim.g['mkdx#settings'] = {
    checkbox = { toggles = { ' ', '-', 'X' } },
    insert_indent_mappings = 1, -- <c-t> to indent, <c-d> to unindent
    -- highlight = { enable = true },
    links = { conceal = 1 },
    map = { prefix = '<leader>m' },
    -- tab = { enable = 0 },
  }
end

---@return nil
local configure_mkdx = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    group = vim.api.nvim_create_augroup('mkdx_map', { clear = true }),
    callback = function() vim.keymap.set('n', '<cr>', '<Plug>(mkdx-checkbox-prev-n)', { buffer = true, noremap = true }) end,
  })

  if not is_installed('which-key') then return end

  require 'which-key'.register({
    m = {
      'Markdown',
      ["'"] = 'Quote Toggle',
      ['-'] = '↓ Checkbox State',
      ['<Leader>'] = '↓ Checkbox State',
      ['='] = '↑ Checkbox State',
      ['/'] = 'Italic',
      ['['] = '↑ Header',
      [']'] = '↓ Header',
      ['`'] = 'Code Block',
      b = 'Bold',
      I = 'TOC Quickfix',
      i = 'TOC Upsert',
      j = 'Jump to Header',
      k = '<kbd>',
      L = 'Links Quickfix',
      s = 'Strikethrough',
      t = 'Checkbox Toggle',
      l = {
        'List',
        l = 'List Toggle',
        n = 'Link Wrap',
        t = 'Checklist Toggle',
      }
    }
  }, { prefix = '<Leader>' })

  require 'which-key'.register({
    m = {
      'Markdown',
      ["'"] = 'Quote Toggle',
      ['-'] = '↓ Checkbox State',
      ['='] = '↑ Checkbox State',
      ['/'] = 'Italic',
      ['['] = '↑ Header',
      [']'] = '↓ Header',
      ['`'] = 'Code Block',
      [','] = 'Tableize',
      b = 'Bold',
      I = 'TOC Quickfix',
      i = 'TOC Upsert',
      j = 'Jump to Header',
      k = '<kbd>',
      L = 'Links Quickfix',
      s = 'Strikethrough',
      t = 'Checkbox Toggle',
      l = {
        'List',
        l = 'List Toggle',
        n = 'Link Wrap',
        t = 'Checklist Toggle',
      }
    }
  }, { prefix = '<Leader>', mode = 'v' })
end

return {
  'SidOfc/mkdx',
  dependencies = 'folke/which-key.nvim', -- this overrides ft... I think because which-key needs to be loaded _before_ something
  ft = 'markdown',
  keys = {
    { "<Leader>m'", desc = 'Quote Toggle' },
    { '<Leader>m-', desc = '↓ Checkbox State' },
    { '<Leader>m=', desc = '↑ Checkbox State' },
    { '<Leader>m/', desc = 'Italic' },
    { '<Leader>m[', desc = '↑ Header' },
    { '<Leader>m]', desc = '↓ Header' },
    { '<Leader>m`', desc = 'Code Block' },
    { '<Leader>m,', desc = 'Tableize' },
    { '<Leader>mb', desc = 'Bold' },
    { '<Leader>mI', desc = 'TOC Quickfix' },
    { '<Leader>mi', desc = 'TOC Upsert' },
    { '<Leader>mj', desc = 'Jump to Header' },
    { '<Leader>mk', desc = '<kbd>'  },
    { '<Leader>mL', desc = 'Links Quickfix' },
    { '<Leader>ms', desc = 'Strikethrough' },
    { '<Leader>mt', desc = 'Checkbox Toggle' },
    { 'Leader>mll', desc = 'List Toggle' },
    { 'Leader>mln', desc = 'Link Wrap' },
    { 'Leader>mlt', desc = 'Checklist Toggle' },
  },
  init = setup_mkdx,
  config = configure_mkdx,
}
