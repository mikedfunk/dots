-- enable if I need any of these
-- vim.g.php_syntax_extensions_enabled = { "bcmath", "bz2", "core", "curl", "date", "dom", "ereg", "gd", "gettext", "hash", "iconv", "json", "libxml", "mbstring", "mcrypt", "mhash", "mysql", "mysqli", "openssl", "pcre", "pdo", "pgsql", "phar", "reflection", "session", "simplexml", "soap", "sockets", "spl", "sqlite3", "standard", "tokenizer", "wddx", "xml", "xmlreader", "xmlwriter", "zip", "zlib" }
vim.g.php_syntax_extensions_enabled = {}

vim.api.nvim_create_augroup('php_textwidth', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'php', group = 'php_textwidth', callback = function() vim.api.nvim_buf_set_option(0, 'textwidth', 80) end })

-- php settings https://github.com/StanAngeloff/php.vim/blob/master/syntax/php.vim#L35-L67
vim.g['php_version_id'] = 70414 -- value of PHP_VERSION_ID constant (7.4)
vim.g['PHP_removeCRwhenUnix'] = 1
vim.g['PHP_outdentphpescape'] = 0 -- means that PHP tags will match the indent of the HTML around them in files that a mix of PHP and HTML
vim.g['php_htmlInStrings'] = 1 -- neat! :h php.vim
vim.g['php_baselib'] = 1 -- highlight php builtin functions
-- g['php_folding'] = 1 -- fold methods, control structures, etc.
-- vim.g['php_phpdoc_folding'] = 1 -- fold phpdoc comments (not working)
vim.g['php_noShortTags'] = 1
vim.g['php_parent_error_close'] = 1 -- highlight missing closing ] or )
vim.g['php_parent_error_open'] = 1 -- highlight missing opening [ or (
vim.g['php_sync_method'] = 10 -- :help :syn-sync https://stackoverflow.com/a/30732393/557215

-- improve php highlights
vim.cmd('hi link phpDocTags phpDefine')
vim.cmd('hi link phpDocParam phpType')
vim.cmd('hi link phpDocParam phpRegion')
vim.cmd('hi link phpDocIdentifier phpIdentifier')
vim.cmd('hi link phpUseNamespaceSeparator Comment') -- Colorize namespace separator in use, extends and implements
vim.cmd('hi link phpClassNamespaceSeparator Comment')

if vim.fn.filereadable '.php-cs-fixer.php' == 1 then
  local ale_fixers = vim.b[0].ale_fixers or (vim.g['ale_fixers'] or {})[vim.bo.filetype] or {}
  if not vim.tbl_contains(ale_fixers, 'php_cs_fixer') then table.insert(ale_fixers, 'php_cs_fixer') end
  vim.b[0].ale_fixers = ale_fixers
end

-- require 'lvim.lsp.manager'.setup('phpactor', {
--   filetypes = { 'php', 'phtml.html' },
--   cmd = {
--     vim.env.HOME .. '/.asdf/installs/php/8.2.12/bin/php',
--     vim.fn.stdpath('data') .. '/mason/bin/phpactor',
--     'language-server'
--   },
-- })
