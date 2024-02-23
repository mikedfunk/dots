-- vim: set foldmethod=marker:

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("all_lsp_attach", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.server_capabilities.document_formatting == true then
      vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})')
    end

    if client.server_capabilities.goto_definition == true then
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
    end
  end
})

local enable_lua_gf = function()
  if not vim.o.ft == 'lua' then return end
  if not vim.fn.isdirectory 'lua' == 1 then return end
  vim.opt_local.path:prepend('lua')
end

vim.api.nvim_create_augroup('lua_gf', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'lua', group = 'lua_gf', callback = enable_lua_gf, desc = 'lua gf' })
vim.api.nvim_create_autocmd('DirChanged', { pattern = 'window', group = 'lua_gf', callback = enable_lua_gf, desc = 'lua gf' })

-- set filetypes for unusual files {{{
-- vim.filetype.add { pattern = { ['.+%.phtml'] = 'php' } }
-- vim.filetype.add { pattern = { ['.+%.blade%.php'] = 'blade.php' } }
-- vim.filetype.add { pattern = { ['.+%.eyaml%.php'] = 'yaml' } }
-- vim.filetype.add { pattern = { ['%.babelrc'] = 'json' } }
-- vim.filetype.add { pattern = { ['%.php%.(sample|dist)'] = 'php' } }
-- vim.filetype.add { pattern = { ['{site,default}.conf'] = 'nginx' } }
-- vim.filetype.add { pattern = { ['.editorconfig'] = 'dosini' } }
-- vim.filetype.add { pattern = { ['{Brewfile,.sshrc,.tigrc,.envrc,.env}'] = 'sh' } }
-- vim.filetype.add { pattern = { ['.env.*'] = 'sh' } }
-- vim.filetype.add { pattern = { ['*.{cnf,hurl}'] = 'dosini' } }
-- vim.filetype.add { pattern = { ['.spacemacs'] = 'lisp' } }
-- vim.filetype.add { pattern = { ['.{curlrc,gitignore,gitattributes,hgignore,jshintignore}'] = 'conf' } }

vim.api.nvim_create_augroup('unusual_filetypes', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.phtml', callback = function() vim.bo.filetype = 'php' end })
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.blade.php', callback = function() vim.bo.filetype = 'blade.php' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.eyaml', callback = function() vim.bo.filetype = 'yaml' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.babelrc', callback = function() vim.bo.filetype = 'json' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.php.{sample,dist}', callback = function() vim.bo.filetype = 'php' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '{site,default}.conf', callback = function() vim.bo.filetype = 'nginx' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.editorconfig', callback = function() vim.bo.filetype = 'dosini' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = 'Brewfile', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.sshrc', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.tigrc', callback = function() vim.bo.filetype = 'gitconfig' end })
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.{env,env.*}', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.{cnf,hurl}', callback = function() vim.bo.filetype = 'dosini' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.spacemacs', callback = function() vim.bo.filetype = 'lisp' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.envrc', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'unusual_filetypes',
  pattern = '{' .. table.concat({
    '.curlrc',
    '.gitignore',
    '.gitattributes',
    '.hgignore',
    '.jshintignore',
  }, ',') .. '}',
  callback = function() vim.bo.filetype = 'conf' end
})
-- }}}

-- comment format (for filetypes that don't have a treesitter parser) {{{
vim.api.nvim_create_augroup('comment_formats', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dosini,haproxy,neon,gitconfig',
  group = 'comment_formats',
  callback = function() vim.o.commentstring = '# %s' end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'plantuml',
  group = 'comment_formats',
  callback = function() vim.o.commentstring = "' %s" end,
})
-- }}}

-- web-based documentation with shift-K {{{
-- https://www.reddit.com/r/vim/comments/3oo1e0/has_anyone_found_a_way_to_make_k_useful/
-- NOTE: keywordprg is not invoked silently, so you will get 'press enter to continue'
-- also I tried to make this fancy and use filetype but neovim doesn't like it
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'zsh,bash,sh',
--   group = 'show_defs',
--   command = 'setlocal keywordprg=devdocs\\ bash',
-- })
-- }}}

-- if the last window is a quickfix, close it {{{
vim.api.nvim_create_augroup('last_quickfix', { clear = true })
vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  group = 'last_quickfix',
  command = "if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix' | q | endif",
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = '[^l]*', group = 'last_quickfix', command = 'cwindow' })
vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = 'l*', group = 'last_quickfix', command = 'lwindow' })
-- }}}
