-- vim: set foldmethod=marker:
vim.b.autoformat = false
vim.bo.commentstring = "// %s"

local php_splitter = function()
  vim.cmd([[exec "norm! 0/\\S->\<cr>a\<cr>\<esc>"]])
end
vim.keymap.set("n", ",.", php_splitter, { noremap = true, buffer = true, desc = "Split PHP" })

vim.keymap.set(
  "n",
  "<Leader>Ps",
  "<Cmd>.,.s/\\/\\*\\* \\(.*\\) \\*\\//\\/\\*\\*\\r     * \\1\\r     *\\//g<cr>",
  { noremap = true, buffer = true, desc = "Split Docblock" }
)
require("which-key").register({ Ps = { "Split Docblock" } })

-- improve php highlights {{{
vim.cmd("hi link phpDocTags phpDefine")
vim.cmd("hi link phpDocParam phpType")
vim.cmd("hi link phpDocParam phpRegion")
vim.cmd("hi link phpDocIdentifier phpIdentifier")
vim.cmd("hi link phpUseNamespaceSeparator Comment") -- Colorize namespace separator in use, extends and implements
vim.cmd("hi link phpClassNamespaceSeparator Comment")
-- }}}
