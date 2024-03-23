-- There is a bug in the autocmd to fire DirOpened, which enables lir. Just load it.
vim.api.nvim_create_augroup('force_load_lir', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'force_load_lir',
  callback = function() vim.cmd 'do User DirOpened' end,
})

return {}
