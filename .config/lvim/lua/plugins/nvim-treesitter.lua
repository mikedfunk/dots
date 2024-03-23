-- TODO: rewrite without lvim global object
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { 'php' } -- needed to make non-treesitter indent work

vim.g.skip_ts_context_commentstring_module = true

lvim.builtin.treesitter.ensure_installed = {
  'comment',
  'lua', -- update to latest
  'luadoc',
  'jsdoc',
  'markdown_inline',
  'phpdoc',
  'regex', -- used by php-enhanced-treesitter
  'sql', -- used by php-enhanced-treesitter
  'vim', -- MUST update from the built-in or my config will cause problems when trying to display
}

lvim.builtin.treesitter.ignore_install = {
  'javascriptreact'
}

lvim.builtin.treesitter.context_commentstring.config.gitconfig = '# %s'
lvim.builtin.treesitter.context_commentstring.config.sql = '-- %s'
lvim.builtin.treesitter.context_commentstring.config.php = '// %s'

for _, filetype in pairs({
  'php',
  -- 'javascript',
  -- 'javascriptreact',
  -- 'typescript',
  -- 'typescriptreact',
}) do
  if not vim.tbl_contains(lvim.builtin.treesitter.indent.disable, filetype) then
    table.insert(lvim.builtin.treesitter.indent.disable, filetype)
  end
end

-- vim.api.nvim_create_augroup('incremental_selection_fix', { clear = true })
-- vim.api.nvim_create_autocmd('cmdwinenter', { pattern = '*', group = 'incremental_selection_fix',
--   command = 'TSBufDisable incremental_selection'
-- })

lvim.builtin.treesitter.auto_install = true
-- this breaks q:
-- lvim.builtin.treesitter.incremental_selection = {
--   enable = true,
--   keymaps = {
--     init_selection = '<cr>',
--     node_incremental = '<cr>',
--     scope_incremental = false,
--     node_decremental = '<bs>',
--   }
-- }

lvim.builtin.treesitter.on_config_done = function()
  -- fancy styled-components queries found on the web
  -- local are_treesitter_styled_components_found, treesitter_styled_components = pcall(require, 'mikedfunk.treesitter_styled_components')
  -- if not are_treesitter_styled_components_found then return end
  -- treesitter_styled_components.directives()
  -- treesitter_styled_components.queries()

  -- THIS BREAKS gg because the shortcuts are already defined in nvim_treesitter_textobjects
  -- local is_whichkey_installed, whichkey = pcall(require, 'which-key')
  -- if not is_whichkey_installed then return end
  -- whichkey.register({
  --   ['>'] = { name = 'Swap Next' },
  --   ['<'] = { name = 'Swap Previous' },
  -- }, { prefix = 'g' })

  require 'nvim-treesitter.parsers'.get_parser_configs().blade = {
    install_info = {
      url = "https://github.com/EmranMR/tree-sitter-blade",
      files = {"src/parser.c"},
      branch = "main",
    },
    filetype = 'blade',
  }
end

return {}
