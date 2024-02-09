---@return nil
local configure_vim_git = function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.keymap.set('n', 'I', '<Cmd>Pick<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'R', '<Cmd>Reword<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'E', '<Cmd>Edit<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'S', '<Cmd>Squash<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'F', '<Cmd>Fixup<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'D', '<Cmd>Drop<cr>', { buffer = current_buf, noremap = true })

  -- need to test these (visual mode)
  vim.keymap.set('v', 'I', ":'<,'>Pick<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'R', ":'<,'>Reword<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'E', ":'<,'>Edit<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'S', ":'<,'>Squash<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'F', ":'<,'>Fixup<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'D', ":'<,'>Drop<cr>", { buffer = current_buf, noremap = true })
end

return { 'tpope/vim-git', ft = 'gitrebase', config = configure_vim_git }
