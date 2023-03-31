local is_installed = require 'mikedfunk.helpers'.is_installed

if is_installed('treesitter') then
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
end
