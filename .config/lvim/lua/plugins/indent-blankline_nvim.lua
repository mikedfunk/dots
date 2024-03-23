if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'mason') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'mason') end
if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') end
lvim.builtin.indentlines.options.show_first_indent_level = false

return {}
