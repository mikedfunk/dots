-- vim: set foldmethod=marker:

-- view uml diagram in browser {{{

---@return nil
local open_uml_image = function()
  local file_path = vim.fn.expand('%')
  if file_path == nil then return end
  vim.fn.system('plantuml ' .. file_path .. ' -tsvg')
  vim.fn.system('open ' .. file_path:gsub('%..-$', '.svg')) -- lua regex is weird
end

---@return nil
local refresh_uml_image = function()
  local file_path = vim.fn.expand('%')
  if file_path == nil then return end
  vim.fn.system('plantuml ' .. file_path .. ' -tsvg')
  vim.fn.system('$(brew --prefix)/bin/terminal-notifier -message "uml diagram reloaded"')
  -- vim.cmd('echom "UML diagram reloaded"')
end

local is_whichkey_installed, which_key = pcall(require, 'which-key')
if is_whichkey_installed then
  which_key.register({
    i = {
      name = 'Image',
      o = { open_uml_image, 'Open' },
      r = { refresh_uml_image, 'Refresh' },
    }
  }, { prefix = '<Leader>' })
end

-- }}}
