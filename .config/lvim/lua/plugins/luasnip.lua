local is_installed = require 'helpers'.is_installed

lvim.builtin.luasnip.build = "make install_jsregexp" -- TODO this doesn't work
-- lvim.builtin.luasnip.update_events = { "TextChanged", "TextChangedI" } -- also not working
if is_installed('luasnip') then
  -- show transformations while you type
  require 'luasnip'.config.setup {
    update_events = { "TextChanged", "TextChangedI" },
  }
  -- strangely these aren't mapped by LunarVim. Doesn't work with noremap... i think because it's already mapped by something else
  vim.keymap.set('i', '<C-E>', '<Plug>luasnip-next-choice', {})
  vim.keymap.set('s', '<C-E>', '<Plug>luasnip-next-choice', {})
end

return {}
