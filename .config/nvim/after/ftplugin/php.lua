-- vim: set foldmethod=marker:
vim.b.autoformat = false
vim.bo.commentstring = "// %s"
-- vim.wo.foldlevel = 1

vim.keymap.set("n", ",.", function()
  vim.cmd(vim.api.nvim_replace_termcodes([[norm! 0/\S-><cr>a<cr><esc>]], true, true, true))
end, { noremap = true, buffer = true, desc = "Split PHP" })

vim.keymap.set(
  "n",
  "<Leader>Ps",
  "<Cmd>.,.s/\\/\\*\\* \\(.*\\) \\*\\//\\/\\*\\*\\r     * \\1\\r     *\\//g<cr>",
  { noremap = true, buffer = true, desc = "Split Docblock" }
)

vim.keymap.set("n", "<Leader>Pq", function()
  vim.cmd([[:command! -range FixThis :silent! '<,'>s/,$//g]], true, true, true)
  vim.cmd(
    vim.api.nvim_replace_termcodes(
      [[:norm I* @param ObjectBehavior<<esc>Ea><esc>V:'<,'>FixThis<cr><esc>]],
      true,
      true,
      true
    )
  )
end, { noremap = true, buffer = true, desc = "Fix Spec Docblock Line" })

vim.keymap.set("n", "<Leader>Pf", function()
  vim.cmd(
    vim.api.nvim_replace_termcodes(
      [[command! -range FixLine :'<,'>norm I* @param ObjectBehavior<<esc>Ea><esc>$x]],
      true,
      true,
      true
    )
  )
  vim.cmd(
    vim.api.nvim_replace_termcodes(
      [[norm "byii[Mjo/**<cr>/<esc>"b[PV/*<cr>k:'<,'>g!/./d<cr><esc>gv<esc>A,<esc>gv:'<,'>FixLine<cr>"]],
      true,
      true,
      true
    )
  )
end, { noremap = true, buffer = true, desc = "Add Spec Docblock" })

-- improve php highlights {{{
vim.cmd("hi link phpDocTags phpDefine")
vim.cmd("hi link phpDocParam phpType")
vim.cmd("hi link phpDocParam phpRegion")
vim.cmd("hi link phpDocIdentifier phpIdentifier")
vim.cmd("hi link phpUseNamespaceSeparator Comment") -- Colorize namespace separator in use, extends and implements
vim.cmd("hi link phpClassNamespaceSeparator Comment")
-- }}}

-- php settings https://github.com/StanAngeloff/php.vim/blob/master/syntax/php.vim#L35-L67 {{{
vim.g["php_version_id"] = 70414 -- value of PHP_VERSION_ID constant (7.4)
vim.g["PHP_removeCRwhenUnix"] = 1
vim.g["PHP_outdentphpescape"] = 0 -- means that PHP tags will match the indent of the HTML around them in files that a mix of PHP and HTML
vim.g["php_htmlInStrings"] = 1 -- neat! :h php.vim
vim.g["php_baselib"] = 1 -- highlight php builtin functions
-- vim.g['php_folding'] = 1 -- fold methods, control structures, etc.
-- vim.g["php_phpdoc_folding"] = 1 -- fold phpdoc comments (not working)
vim.g["php_noShortTags"] = 1
vim.g["php_parent_error_close"] = 1 -- highlight missing closing ] or )
vim.g["php_parent_error_open"] = 1 -- highlight missing opening [ or (
vim.g["php_sync_method"] = 10 -- :help :syn-sync https://stackoverflow.com/a/30732393/557215
-- }}}
