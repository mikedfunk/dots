local is_installed = require 'mikedfunk.helpers'.is_installed

-- vim.wo.foldlevel = 1
-- if is_installed('ufo') then require 'ufo'.closeFoldsWith(1) end

-- NOTE: I tried to put the filetypes config in intelephense.json but that didn't get picked up at all
-- I also tried that while doing automatic configuration (generated ftplugin), still no dice

local capabilities = require 'lvim.lsp'.common_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

if not _G.was_intelephense_setup then
  require 'lvim.lsp.manager'.setup('intelephense', {
    filetypes = { 'php', 'phtml.html' },
    capabilities = capabilities,
  })
  require 'ufo'.setup {
    close_fold_kinds = {
      -- lsp:
      'comment',
      'imports',
      'region',

      -- treesitter:
      -- 'method_declaration',
      -- 'comment',
      -- 'namespace_use_declaration',
      -- 'property_declaration',
    }
  }
  -- require 'ufo'.closeFoldsWith(1)
  _G.was_intelephense_setup = true
end

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