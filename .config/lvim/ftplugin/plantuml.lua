-- vim: set foldmethod=marker:

local is_installed = require 'mikedfunk.helpers'.is_installed

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

if is_installed('which-key') then
  require 'which-key'.register({
    i = {
      name = 'Image',
      o = { open_uml_image, 'Open' },
      r = { refresh_uml_image, 'Refresh' },
    }
  }, { prefix = '<Leader>' })
end

-- }}}
