-- vim: set foldmethod=marker:
vim.b.autoformat = false -- too slow
vim.bo.commentstring = "// %s"
-- vim.wo.foldlevel = 1

-- moved from autocmds.lua
-- vim.cmd("norm mz")
-- vim.cmd([[silent! g/^use /normal! zc]]) -- Collapse only `use` statements
-- vim.cmd("norm `z")
-- vim.cmd("delmarks z")

vim.keymap.set("n", ",.", function()
  vim.cmd(vim.api.nvim_replace_termcodes([[norm! 0/\S-><cr>a<cr><esc>]], true, true, true))
end, { noremap = true, buffer = true, desc = "Split PHP" })

-- Turn /** Test */ into:
--
-- /**
--  * Test
--  */
vim.keymap.set("n", "<Leader>Ps", function()
  vim.cmd([[s/\/\*\* \(.*\) \*\//\/\*\*\r     * \1\r     *\//]])
  vim.cmd([[?/\*\*]])
  vim.cmd([[norm V]])
  vim.cmd([[/\*\/]])
  vim.cmd([[silent! :norm =]])
  vim.cmd([[noh]])
end, { noremap = true, buffer = true, desc = "Split Docblock" })

-- Turn:
--
-- /**
--  SomeClass $someVar <-- cursor is anywhere on this line
--  */
--
--  into:
--
--  /**
--   * @param ObjectBehavior<SomeClass> $someVar
--   */
vim.keymap.set("n", "<Leader>Pq", function()
  -- vim.api.nvim_buf_create_user_command(0, "FixThis", "silent! s/,$//g", {})
  vim.cmd([[:command! -range FixThis :silent! s/,$//g]])
  vim.cmd(
    vim.api.nvim_replace_termcodes(
      [[:norm I* @param ObjectBehavior<<esc>Ea><esc>V:'<,'>FixThis<cr><esc>]],
      true,
      true,
      true
    )
  )
end, { noremap = true, buffer = true, desc = "Fix Spec Docblock Line" })

-- Turn:
--
-- public function (
--     SomeClass1 $someVar1, <-- cursor is anywhere in this indent area
--     SomeClass2 $someVar2
-- ): void {
--
--  into:
--
--  /**
--   * @param ObjectBehavior<SomeClass1> $someVar1
--   * @param ObjectBehavior<SomeClass2> $someVar2
--   */
-- public function (
--     SomeClass1 $someVar1,
--     SomeClass2 $someVar2
-- ): void {
vim.keymap.set("n", "<Leader>Pf", function()
  -- These can probably be simplified. I definitely need replace_termcodes somewhere though.
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
-- :Inspect to see current highlight group
vim.cmd("hi link phpDocTags phpDefine")
vim.cmd("hi link phpDocParam phpType")
vim.cmd("hi link phpDocParam phpRegion")
vim.cmd("hi link phpDocIdentifier phpIdentifier")
vim.cmd("hi link phpUseNamespaceSeparator Comment") -- Colorize namespace separator in use, extends and implements
vim.cmd("hi link phpClassNamespaceSeparator Comment")
-- }}}

-- php settings https://github.com/StanAngeloff/php.vim/blob/master/syntax/php.vim#L35-L67 {{{
vim.g["php_version_id"] = 80401 -- value of PHP_VERSION_ID constant (8.4)
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
