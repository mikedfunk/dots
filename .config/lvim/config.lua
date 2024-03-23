require 'options'
require 'keymaps'
require 'autocmds'

lvim.format_on_save.pattern = table.concat({
  '*.css',
  '*.js',
  '*.jsx',
  '*.lua',
  '*.md',
  '*.php',
  '*.tsx',
  '*.yml',
}, ',')
lvim.format_on_save.timeout = 30000

lvim.icons.git.FileUnstaged = '✎'
-- lvim.icons.git.FileUntracked = '󱙄'
lvim.icons.git.FileUntracked = '󱃓'
lvim.icons.git.FileStaged = '✓'

-- put file-based plugins in lvim.plugins
local plugins = vim.api.nvim_get_runtime_file('lua/plugins/*', true)
lvim.plugins = {}

for _, plugin in pairs(plugins) do
  local path = string.gsub(plugin, "^.*/(plugins/[a-zA-Z0-9_-]+)%.lua", "%1")
  table.insert(lvim.plugins, require(path))
end
