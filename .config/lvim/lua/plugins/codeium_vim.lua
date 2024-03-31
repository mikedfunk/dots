-- TODO: rewrite without lvim global object
return {
  'Exafunction/codeium.vim',
  dependencies = 'folke/which-key.nvim',
  event = 'BufEnter',
  init = function()
    vim.g.codeium_disable_bindings = 1
  end,
  config = function()
    vim.keymap.set('i', '<m-tab>', vim.fn['codeium#Accept'], { noremap = true, expr = true, desc = 'Codeium Accept' })
    vim.keymap.set('i', '<m-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { noremap = true, expr = true, desc = 'Next Codeium Completion' })
    vim.keymap.set('i', '<m-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { noremap = true, expr = true, desc = 'Prev Codeium Completion' })
    vim.keymap.set('i', '<m-x>', vim.fn['codeium#Clear'], { noremap = true, expr = true, desc = 'Codeium Clear' })
    vim.keymap.set('i', '<m-i>', vim.fn['codeium#Complete'], { noremap = true, expr = true, desc = 'Codeium Complete' })
    vim.keymap.set('n', '<leader>lO', function() if vim.fn['codeium#Enabled']() == true then vim.cmd 'CodeiumDisable' else vim.cmd 'CodeiumEnable' end end, { noremap = true, desc = 'Toggle Codeium' })
    require 'which-key'.register({ lO = { 'Toggle Codeium' } })
  end
}
