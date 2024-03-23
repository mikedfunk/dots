-- vim: set fdm=marker:

-- send hurl request {{{
-- TODO: replace with https://github.com/jellydn/hurl.nvim
-- command Exec set splitright | vnew | set filetype=sh | read !sh #
local send_hurl_request = function()
  local file_path = vim.fn.expand('%')
  if file_path == nil then return end
  vim.cmd('silent! only')
  vim.cmd('vnew')
  vim.bo.filetype = 'json'
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'
  vim.bo.swapfile = false
  vim.cmd('read !hurl ' .. file_path .. ' | jq')
  vim.cmd('norm gg')
  vim.cmd('wincmd w')
end

local is_whichkey_installed, whichkey = pcall(require, 'which-key')
if is_whichkey_installed then
  whichkey.register({
    h = {
      name = 'Hurl',
      s = { send_hurl_request, 'Send' },
    }
  }, { prefix = '<Leader>' })
end
-- }}}
