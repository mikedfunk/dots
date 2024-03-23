-- TODO: rewrite without lvim global object
if not vim.tbl_contains(lvim.builtin.project.patterns, 'composer.json') then table.insert(lvim.builtin.project.patterns, 'composer.json') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'config.lua') then table.insert(lvim.builtin.project.patterns, 'config.lua') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'bootstrap') then table.insert(lvim.builtin.project.patterns, 'bootstrap') end

return {}
