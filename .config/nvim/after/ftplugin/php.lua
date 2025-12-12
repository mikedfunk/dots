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
-- ```php
-- public function (
--     SomeClass1 $someVar1, <-- cursor is anywhere in this indent area
--     SomeClass2 $someVar2
-- ): void {
-- ```
--
-- or:
--
-- ```php
-- public function (
--     SomeClass1 $someVar1, <-- cursor is anywhere in this indent area
--
--     SomeClass2 $someVar2
-- ): void {
-- ```
--
--  into:
--
-- ```php
--  /**
--   * @param ObjectBehavior<SomeClass1> $someVar1
--   * @param ObjectBehavior<SomeClass2> $someVar2
--   */
-- public function (
--     SomeClass1 $someVar1,
--     SomeClass2 $someVar2
-- ): void {
-- ```
vim.keymap.set("n", "<Leader>Pf", function()
  local api = vim.api
  local bufnr = api.nvim_get_current_buf()
  local cursor = api.nvim_win_get_cursor(0)
  local cur_line = cursor[1]

  -- 1. Find the line with '(' that starts the parameters
  local start_line = cur_line
  while start_line > 0 do
    local line_text = api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]
    if line_text:match("%(") then
      break
    end
    start_line = start_line - 1
  end

  -- capture indentation of function line
  local func_line_text = api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]
  local indent = func_line_text:match("^%s*") or ""

  -- 2. Find end of parameters (line with ')')
  local end_line = start_line
  local last_line = api.nvim_buf_line_count(bufnr)
  while end_line <= last_line do
    local line_text = api.nvim_buf_get_lines(bufnr, end_line - 1, end_line, false)[1]
    if line_text:match("%)") then
      break
    end
    end_line = end_line + 1
  end

  -- 3. Collect parameter lines
  local param_lines = api.nvim_buf_get_lines(bufnr, start_line, end_line - 1, false)
  local doc_lines = { indent .. "/**" }

  for _, line in ipairs(param_lines) do
    if line:match("%S") then
      local typ, var = line:match("^%s*([%w\\_]+)%s*(%$[%w_]+)")
      if typ and var then
        table.insert(doc_lines, string.format("%s * @param ObjectBehavior<%s> %s", indent, typ, var))
      end
    end
  end

  table.insert(doc_lines, indent .. " */")

  -- 4. Insert docblock above function line
  api.nvim_buf_set_lines(bufnr, start_line - 1, start_line - 1, false, doc_lines)
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
vim.g["php_version_id"] = 80405 -- value of PHP_VERSION_ID constant (8.4)
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
