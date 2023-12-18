-- vim: set foldmethod=marker:

vim.loader.enable() -- enable experimental module loader

-- notes {{{
-- https://github.com/sumneko/lua-language-server/wiki/EmmyLua-Annotations#types-and-type
-- }}}

-- helpers {{{
local is_installed = require 'mikedfunk.helpers'.is_installed
-- local dump = require 'mikedfunk.helpers'.dump

-- this was recently changed... use the same one that lunarvim sets up
local mason_path = vim.fn.stdpath('data') .. '/mason'

vim.api.nvim_exec([[
function! LocListToggle()
  if empty(filter(getwininfo(), 'v:val.loclist'))
    lopen
  else
    lclose
  endif
endfunction
]], false)
-- }}}

-- vim options {{{
vim.o.joinspaces = false -- Prevents inserting two spaces after punctuation on a join (J)
vim.o.swapfile = true -- I hate them but they help if neovim crashes

-- https://github.com/luukvbaal/stabilize.nvim
vim.o.splitkeep = "screen"

vim.o.spellfile = vim.fn.expand(vim.env.LUNARVIM_CONFIG_DIR .. '/spell/en.utf-8.add') -- this is necessary because nvim-treesitter is first in the runtimepath
vim.o.spelloptions = table.concat({
  'noplainbuffer',
  'camel',
}, ',')
-- vim.o.foldlevel = 99 -- default high foldlevel so files are not folded on read
vim.o.formatoptions = 'croqjt'
vim.o.timeoutlen = 250 -- trying this out for which-key.nvim
-- vim.o.textwidth = 80 -- line width to break on with <visual>gw TODO: getting overridden to 999 somewhere
vim.o.relativenumber = true -- relative line numbers
vim.o.mousemoveevent = true -- enable hover X on bufferline tabs

-- turn off relativenumber in insert mode and others {{{
local norelative_events = { 'InsertEnter', 'WinLeave', 'FocusLost' }
local relative_events = { 'InsertLeave', 'WinEnter', 'FocusGained', 'BufNewFile', 'BufReadPost' }
vim.api.nvim_create_augroup('relnumber_toggle', { clear = true })
vim.api.nvim_create_autocmd(relative_events, {
  group = 'relnumber_toggle',
  callback = function()
    if vim.o.number then vim.o.relativenumber = true end
  end,
  desc = 'turn on relative number',
})
vim.api.nvim_create_autocmd(norelative_events, {
  group = 'relnumber_toggle',
  callback = function()
    if vim.o.number then vim.o.relativenumber = false end
  end,
  desc = 'turn off relative number',
})
-- }}}

vim.o.fillchars = table.concat({
  'eob: ', -- remote tildes in startify
  'diff:/', -- for removed blocks, set bg to diagonal lines
  'fold: ',
}, ',')

-- ripped from here https://github.com/tamton-aquib/essentials.nvim/blob/main/lua/essentials.lua
---@return string: foldtext
_G.simple_fold = function()
  local fs, fe = vim.v.foldstart, vim.v.foldend
  local start_line = vim.fn.getline(fs):gsub('\t', ('\t'):rep(vim.opt.ts:get())) ---@diagnostic disable-line undefined-field
  local end_line = vim.trim(vim.fn.getline(fe)) ---@diagnostic disable-line param-type-mismatch
  local spaces = (' '):rep(vim.o.columns - start_line:len() - end_line:len() - 7)

  -- return start_line .. '  ' .. end_line .. spaces
  return start_line .. ' … ' .. end_line .. spaces
end
vim.opt.foldtext = 'v:lua.simple_fold()'

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.api.nvim_create_augroup('hi_yanked_text', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'hi_yanked_text',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
  desc = 'highlight yanked text',
})

vim.opt.cmdheight = 0 -- height of the bottom line that shows command output. I don't like lvim's default of 2.
vim.opt.showtabline = 1 -- show tabs only when more than one file
vim.o.inccommand = 'split' -- preview substitute in neovim `:h inccommand`
vim.o.foldcolumn = 'auto' -- make folds visible left of the sign column. Very cool ui feature!
-- vim.o.lazyredraw = true -- to speed up rendering and avoid scrolling problems (noice doesn't like this)
-- vim.o.hlsearch = false -- disable auto highlight all search results, this is handled by highlight-current-n
vim.o.pumblend = 15 -- popup pseudo-transparency
vim.o.winblend = 15 -- floating window pseudo-transparency
vim.o.exrc = true -- TODO: not working
vim.o.secure = true
-- vim.o.smartindent = true -- Do smart autoindenting when starting a new line. Absolute must.
-- vim.o.autoindent = true
vim.o.laststatus = 3 -- new neovim global statusline
if vim.fn.filereadable '/usr/share/dict/words' == 1 then vim.opt.dictionary:append('/usr/share/dict/words') end -- :h dictionary
-- vim.o.updatetime = 650 -- wait time before CursorHold activation
vim.o.updatetime = 100 -- wait time before CursorHold activation

vim.cmd 'packadd! cfilter'

-- vim-cool replacement https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/iyvcdf0/
vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    local new_hlsearch = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end, vim.api.nvim_create_namespace 'auto_hlsearch')

-- avoids lag when scrolling
-- https://github.com/vimpostor/vim-tpipeline#how-do-i-update-the-statusline-on-every-cursor-movement
-- vim.cmd 'set guicursor='

if vim.fn.executable('ag') == 1 then
  vim.o.grepprg = 'ag --vimgrep'
  vim.o.grepformat = '%f:%l:%c%m'
elseif vim.fn.executable('git') == 1 then
  vim.o.grepprg = 'git grep'
  vim.o.grepformat = '%f:%l:%m,%m %f match%ts,%f'
end

vim.cmd("cabbr <expr> %% expand('%:p:h')") -- in ex mode %% is current dir
vim.o.sessionoptions = table.concat({
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
  'globals',
}, ',')

-- if the last window is a quickfix, close it
vim.api.nvim_create_augroup('last_quickfix', { clear = true })
vim.api.nvim_create_autocmd('WinEnter', {
  pattern = '*',
  group = 'last_quickfix',
  command = "if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix' | q | endif",
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = '[^l]*', group = 'last_quickfix', command = 'cwindow' })
vim.api.nvim_create_autocmd('QuickFixCmdPost', { pattern = 'l*', group = 'last_quickfix', command = 'lwindow' })

-- bug: I don't see a way to apply _local_ iabbrevs so if you load a
-- markdown file it will enable the abbrev in the entire workspace :/

-- comment format (for filetypes that don't have a treesitter parser)
vim.api.nvim_create_augroup('comment_formats', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'dosini,haproxy,neon,gitconfig', group = 'comment_formats', callback = function() vim.o.commentstring = '# %s' end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'plantuml', group = 'comment_formats', callback = function() vim.o.commentstring = "' %s" end })

-- open quickfix in vsplit, tab, split
vim.api.nvim_create_augroup('quickfix_splits', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', group = 'quickfix_splits', callback = function() vim.keymap.set('n', 's', '<C-w><Enter>', { buffer = true }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', group = 'quickfix_splits', callback = function() vim.keymap.set('n', 'v', '<C-w><Enter><C-w>L', { buffer = true }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', group = 'quickfix_splits', callback = function() vim.keymap.set('n', 't', '<C-w><Enter><C-w>T', { buffer = true }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', group = 'quickfix_splits', command = 'wincmd J' })

vim.api.nvim_create_augroup('show_defs', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'vim',
  group = 'show_defs',
  callback = function()
    vim.keymap.set('n', 'K', '<Esc>:help <C-R><C-W><CR>', { noremap = true, silent = true, buffer = true })
  end,
})
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<Cmd>SymbolsOutline<CR>', { noremap = true })
-- web-based documentation with shift-K
-- https://www.reddit.com/r/vim/comments/3oo1e0/has_anyone_found_a_way_to_make_k_useful/
-- NOTE: keywordprg is not invoked silently, so you will get 'press enter to continue'
-- also I tried to make this fancy and use filetype but neovim doesn't like it
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'zsh,bash,sh',
  group = 'show_defs',
  command = 'setlocal keywordprg=devdocs\\ bash',
})

-- show vert lines at the psr-2 suggested column limits
vim.o.colorcolumn = table.concat({
  80,
  120
}, ',')

-- only show colorcolumn when over {{{
-- (like https://github.com/m4xshen/smartcolumn.nvim but works for multiple)

-- --- @param colorcolumn integer
-- --- @return boolean
-- local function is_a_line_over_colorcolumn(colorcolumn)
--   local max_column = 0
--   local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
--   for _, line in pairs(lines) do
--     max_column = math.max(max_column, vim.fn.strdisplaywidth(line))
--   end

--   return max_column > colorcolumn
-- end

-- local colorcolumns = { 80, 120 }
-- local function enable_colorcolumns_if_over()
--   local enabled_colorcolumns = {}
--   for _, colorcolumn in ipairs(colorcolumns) do
--     if is_a_line_over_colorcolumn(colorcolumn) then
--       table.insert(enabled_colorcolumns, colorcolumn)
--     end
--   end

--   if enabled_colorcolumns ~= {} then
--     vim.wo.colorcolumn = table.concat(enabled_colorcolumns, ',')
--   end
-- end

-- vim.api.nvim_create_augroup('color_column_over', { clear = true })
-- vim.api.nvim_create_autocmd('CursorHold', {
--   group = 'color_column_over',
--   callback = enable_colorcolumns_if_over,
--   desc = 'enable colorcolumns if over',
-- })
-- }}}

-- prettier hidden chars. turn on with :set list or yol (different symbols)
vim.o.listchars = table.concat({
  'nbsp:␣',
  'tab:▸•',
  'eol:↲',
  'trail:•',
  'extends:»',
  'precedes:«',
  'trail:•',
}, ',')

vim.cmd('highlight! Comment cterm=italic, gui=italic') -- italic comments https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
vim.cmd('highlight! Special cterm=italic, gui=italic')

-- vim.lsp.set_log_level("debug") -- enable lsp debug logging - you can open the log with :lua vim.cmd('e'..vim.lsp.get_log_path()) or tail -f ~/.local/state/nvim/lsp.log

-- https://www.reddit.com/r/neovim/comments/opipij/guide_tips_and_tricks_to_reduce_startup_and/
local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  -- 'spellfile_plugin'
}
for _, plugin in pairs(disabled_built_ins) do vim.g['loaded_' .. plugin] = 1 end

local enable_lua_gf = function()
  if not vim.o.ft == 'lua' then return end
  if not vim.fn.isdirectory 'lua' == 1 then return end
  vim.opt_local.path:prepend('lua')
end

vim.api.nvim_create_augroup('lua_gf', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'lua', group = 'lua_gf', callback = enable_lua_gf, desc = 'lua gf' })
vim.api.nvim_create_autocmd('DirChanged', { pattern = 'window', group = 'lua_gf', callback = enable_lua_gf, desc = 'lua gf' })

-- use latest node and php version
vim.env.PATH = vim.env.HOME .. '/.asdf/installs/nodejs/17.8.0/bin:' .. vim.env.PATH
-- vim.env.PATH = vim.env.HOME .. '/.asdf/installs/php/8.2.12/bin:' .. vim.env.PATH

-- Fold Textobject Maps: {{{
vim.keymap.set('o', 'iz', '<Cmd>normal! [zj0v]zk$<CR>', { noremap = true })
vim.keymap.set('x', 'iz', '<Cmd>normal! [zj0o]zk$<CR>', { noremap = true })
vim.keymap.set('o', 'az', '<Cmd>normal! [zv]z$<CR>', { noremap = true })
vim.keymap.set('x', 'az', '<Cmd>normal! [zo]z$<CR>', { noremap = true })
-- }}}

-- Close current window and all its floating subwindows https://github.com/neovim/neovim/issues/11440 {{{

---@return nil
local close_win_and_floats = function()
  local this_win = vim.fn.win_getid()
  -- close all floating windows that are relative to the current one
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_config = vim.api.nvim_win_get_config(win)
    -- If the mapping doesn't close enough windows, use the following line instead:
    -- if win_config.relative ~= "" then
    if win_config.relative == 'win' and win_config.win == this_win then ---@diagnostic disable-line undefined-field
      vim.api.nvim_win_close(win, false)
    end
  end
  -- close current window
  vim.cmd('quit')
end

vim.keymap.set('n', '<C-w>c', close_win_and_floats, { noremap = true })
vim.keymap.set('n', 'ZQ', close_win_and_floats, { noremap = true })
-- }}}

-- vim-markdown (builtin) {{{
-- https://github.com/tpope/vim-markdown
vim.g['markdown_fold_style'] = 'nested'
vim.g['markdown_folding'] = 1
-- vim.g['markdown_syntax_conceal'] = 0
vim.g['markdown_minlines'] = 100

-- https://old.reddit.com/r/vim/comments/2x5yav/markdown_with_fenced_code_blocks_is_great/
vim.g['markdown_fenced_languages'] = {
  'css',
  'html',
  'javascript=javascript.jsx',
  'js=javascript.jsx',
  'json=javascript',
  'lua',
  'php',
  'python',
  'ruby',
  'scss',
  'sh',
  'sql',
  'typescript',
  'typescriptreact',
  'xml',
}
-- }}}

-- set filetypes for unusual files {{{
-- vim.filetype.add { pattern = { ['.+%.phtml'] = 'php' } }
-- vim.filetype.add { pattern = { ['.+%.blade%.php'] = 'blade.php' } }
-- vim.filetype.add { pattern = { ['.+%.eyaml%.php'] = 'yaml' } }
-- vim.filetype.add { pattern = { ['%.babelrc'] = 'json' } }
-- vim.filetype.add { pattern = { ['%.php%.(sample|dist)'] = 'php' } }
-- vim.filetype.add { pattern = { ['{site,default}.conf'] = 'nginx' } }
-- vim.filetype.add { pattern = { ['.editorconfig'] = 'dosini' } }
-- vim.filetype.add { pattern = { ['{Brewfile,.sshrc,.tigrc,.envrc,.env}'] = 'sh' } }
-- vim.filetype.add { pattern = { ['.env.*'] = 'sh' } }
-- vim.filetype.add { pattern = { ['*.{cnf,hurl}'] = 'dosini' } }
-- vim.filetype.add { pattern = { ['.spacemacs'] = 'lisp' } }
-- vim.filetype.add { pattern = { ['.{curlrc,gitignore,gitattributes,hgignore,jshintignore}'] = 'conf' } }

vim.api.nvim_create_augroup('unusual_filetypes', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.phtml', callback = function() vim.bo.filetype = 'php' end })
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.blade.php', callback = function() vim.bo.filetype = 'blade.php' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.eyaml', callback = function() vim.bo.filetype = 'yaml' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.babelrc', callback = function() vim.bo.filetype = 'json' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.php.{sample,dist}', callback = function() vim.bo.filetype = 'php' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '{site,default}.conf', callback = function() vim.bo.filetype = 'nginx' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.editorconfig', callback = function() vim.bo.filetype = 'dosini' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = 'Brewfile', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.sshrc', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.tigrc', callback = function() vim.bo.filetype = 'gitconfig' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.{env,env.*}', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '*.{cnf,hurl}', callback = function() vim.bo.filetype = 'dosini' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.spacemacs', callback = function() vim.bo.filetype = 'lisp' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.envrc', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'unusual_filetypes',
  pattern = '{' .. table.concat({
    '.curlrc',
    '.gitignore',
    '.gitattributes',
    '.hgignore',
    '.jshintignore',
  }, ',') .. '}',
  callback = function() vim.bo.filetype = 'conf' end
})
-- }}}

-- automatically jump to the last place you've visited in a file before exiting {{{
-- https://this-week-in-neovim.org/2023/Jan/02#tips
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   callback = function()
--     local mark = vim.api.nvim_buf_get_mark(0, '"')
--     local lcount = vim.api.nvim_buf_line_count(0)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })
-- }}}

-- lsp config {{{
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = 'rounded',
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = 'rounded'
  }
)

vim.diagnostic.config {
  float = { border = 'rounded' }
}
-- }}}

-- }}}

-- lvim options {{{

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

-- icons {{{
lvim.icons.git.FileUnstaged = '✎'
-- lvim.icons.git.FileUntracked = '󱙄'
lvim.icons.git.FileUntracked = '󱃓'
lvim.icons.git.FileStaged = '✓'
-- }}}

-- language servers {{{
-- lvim.lsp.installer.setup.automatic_installation = { exclude = { 'phpactor' } }
-- NOTE: this is not just ensure installed, if these have language server
-- configs it will try to set them up as language servers. This is not what
-- I want for phpactor for instance. You must use the same keys as from
-- nvim-lspconfig. This does not include non-lsp tools.

-- contextive language server (not in mason-lspconfig or nvim-lspconfig pinned versions in LunarVim yet) {{{
local function setup_contextive_ls()
  local is_nvim_lsp_installed, nvim_lsp = pcall(require, 'lspconfig')
  if is_nvim_lsp_installed and not require 'lspconfig.configs'.contextive then
    require 'lspconfig.configs'.contextive = {
      default_config = {
        cmd = { 'Contextive.LanguageServer' },
        root_dir = nvim_lsp.util.root_pattern('.contextive', '.git'),
      };
    }
  end
  require 'lspconfig'.contextive.setup { autostart = false }
end

if vim.fn.executable('Contextive.LanguageServer') == 1 then
  setup_contextive_ls()
else
  local is_mason_installed, registry = pcall(require, 'mason-registry')
  if is_mason_installed and not registry.is_installed('contextive') then
    vim.notify_once("Installation in progress for contextive", vim.log.levels.INFO)
    local package = registry.get_package('contextive')
    package:install():once('closed', function()
      if package:is_installed() then
        vim.schedule(function()
          vim.notify_once('Installation complete for contextive', vim.log.levels.INFO)
          setup_contextive_ls()
        end)
      end
    end)
  end
end
-- }}}

-- when you run :LvimCacheReset
-- this will GENERATE an ftplugin to run lspconfig setup with no opts!
-- https://github.com/LunarVim/LunarVim/blob/30c65cfd74756954779f3ea9d232938e642bc07f/lua/lvim/lsp/templates.lua
-- available keys are here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
lvim.lsp.installer.setup.ensure_installed = {
  'cssls',
  'cucumber_language_server',
  'docker_compose_language_service',
  'dockerls',
  'emmet_language_server',
  'intelephense',
  'jsonls',
  'lemminx',
  'lua_ls', -- aka sumneko_lua
  'ruff_lsp', -- python linter lsp (replaces flake8)
  'sqlls', -- https://github.com/joe-re/sql-language-server/issues/128
  'tailwindcss',
  'taplo',
  'yamlls',
  'zk',
  -- 'astro',
  -- 'autotools-language-server', -- TODO: enable this once mason-lspconfig is upgraded
  -- 'bashls',
  -- 'contextive', -- DDD definition helper (not in mason-lspconfig yet)
  -- 'cssmodules_ls',
  -- 'denols',
  -- 'emberls',
  -- 'eslint', -- eslint-lsp (stopped working on node 17.8.0, lsp debug isn't showing any errors)
  -- 'glint', -- typed ember
  -- 'graphql',
  -- 'jqls',
  -- 'nginx_language_server', -- not in mason-lspconfig yet
  -- 'phpactor', -- I use intelephense. This requires PHP 8.0+.
  -- 'prismals', -- node ORM
  -- 'pyright', -- just use ruff-lsp
  -- 'relay_lsp', -- react framework
  -- 'remark_ls',
  -- 'ruby_ls', -- using the recommended solargraph instead
  -- 'snyk-ls', -- not on null-ls or nvim-lspconfig yet
  -- 'solargraph',
  -- 'sqls' -- just doesn't do anything, is archived
  -- 'svelte',
  -- 'tsserver', -- handled by typescript.nvim instead
  -- 'vimls',
  -- 'vuels',
}

lvim.lsp.document_highlight = true

-- remove toml from skipped filetypes so I can configure taplo
lvim.lsp.automatic_configuration.skipped_filetypes = vim.tbl_filter(function(val)
  return not vim.tbl_contains({ 'toml' }, val)
end, lvim.lsp.automatic_configuration.skipped_filetypes)

for _, server in pairs({
  'phpactor', -- requires php 8.0+
  'tsserver',
  -- 'intelephense',
  -- 'solargraph',
  -- 'standardrb',
}) do
  if not vim.tbl_contains(lvim.lsp.automatic_configuration.skipped_servers, server) then
    table.insert(lvim.lsp.automatic_configuration.skipped_servers, server)
  end
end

-- flow: moved to ./after/ftplugin/javascript.lua
-- tsserver: moved to typescript.nvim

-- snyk-ls {{{
-- commented out because this opens a browser window every time to login :(
-- local function setup_language_server()
--   vim.lsp.start {
--     name = 'snyk_ls',
--     cmd = {'snyk-ls'},
--     settings = {
--       token = vim.env.SNYK_TOKEN
--     },
--     root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
--   }
-- end

-- if vim.fn.executable('snyk-ls') == 1 then
--   setup_language_server()
-- else
--   local is_mason_installed, registry = pcall(require, 'mason-registry')
--   if is_mason_installed and not registry.is_installed('snyk-ls') then
--     vim.notify_once("Installation in progress for snyk-ls", vim.log.levels.INFO)
--     local package = registry.get_package('snyk-ls')
--     package:install():once('closed', function()
--       if package:is_installed() then
--         vim.schedule(function()
--           vim.notify_once('Installation complete for snyk-ls', vim.log.levels.INFO)
--           setup_language_server()
--         end)
--       end
--     end)
--   end
-- end
-- }}}

-- }}}

-- builtin plugins {{{

lvim.builtin.bufferline.active = true -- bufferline.nvim
lvim.builtin.dap.active = true -- nvim-dap
lvim.builtin.alpha.active = false -- alpha.nvim
lvim.builtin.lualine.active = true
-- lvim.builtin.notify.active = true -- nvim-notify
lvim.builtin.terminal.active = true -- toggleterm.nvim (useful to tail logs with <leader>Ll..)

-- bufferline.nvim {{{
vim.cmd [[hi! default link PanelHeading BufferLineTabSelected]]
vim.api.nvim_create_augroup('bufferline_fill_fix', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'bufferline_fill_fix',
  callback = function() vim.cmd [[silent! hi! link BufferLineFill BufferLineGroupSeparator]] end,
})

-- -- Bufferline tries to make everything italic. Why?
-- moved to no_italic below
-- lvim.builtin.bufferline.highlights.background = { italic = false }
-- lvim.builtin.bufferline.highlights.buffer_selected.italic = false
-- lvim.builtin.bufferline.highlights.diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.hint_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.hint_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.info_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.info_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.warning_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.warning_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.error_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.error_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate_visible = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate = { italic = false }
-- lvim.builtin.bufferline.highlights.pick_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.pick_visible = { italic = false }
-- lvim.builtin.bufferline.highlights.pick = { italic = false }

lvim.builtin.bufferline.options.persist_buffer_sort = true
lvim.builtin.bufferline.options.hover.enabled = true
lvim.builtin.bufferline.options.sort_by = 'insert_after_current'
lvim.builtin.bufferline.options.always_show_bufferline = true
lvim.builtin.bufferline.options.separator_style = 'slant'
-- lvim.builtin.bufferline.options.numbers = 'ordinal'

-- remove all sidebar headers
for k, _ in ipairs(lvim.builtin.bufferline.options.offsets) do
  lvim.builtin.bufferline.options.offsets[k].text = nil
end

if is_installed('bufferline') then
  lvim.builtin.bufferline.options.groups = lvim.builtin.bufferline.options.groups or {}
  lvim.builtin.bufferline.options.groups.items = lvim.builtin.bufferline.options.groups.items or {}
  table.insert(
    lvim.builtin.bufferline.options.groups.items,
    require 'bufferline.groups'.builtin.pinned:with { icon = "" }
  )

  lvim.builtin.bufferline.options.style_preset = require 'bufferline'.style_preset.no_italic
end
-- }}}

-- gitsigns.nvim {{{

lvim.builtin.gitsigns.opts.yadm.enable = true

-- consistency with nvim-tree and makes more sense than the default
lvim.builtin.gitsigns.opts.signs.delete.text = ''
lvim.builtin.gitsigns.opts.signs.topdelete.text = ''
-- }}}

-- indent-blankline.nvim {{{
if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'mason') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'mason') end
if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') end
lvim.builtin.indentlines.options.show_first_indent_level = false
-- }}}

-- lir.nvim {{{
-- There is a bug in the autocmd to fire DirOpened, which enables lir. Just load it.
vim.api.nvim_create_augroup('force_load_lir', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'force_load_lir',
  callback = function() vim.cmd 'do User DirOpened' end,
})
-- }}}

-- lualine {{{
lvim.builtin.lualine.style = 'default'
lvim.builtin.lualine.options.disabled_filetypes = { 'startify', 'TelescopePrompt' }
lvim.builtin.lualine.extensions = { 'quickfix', 'nvim-tree', 'symbols-outline', 'fugitive' } -- https://github.com/nvim-lualine/lualine.nvim#extensions

local components = require 'lvim.core.lualine.components'

components.filetype.on_click = function() vim.cmd 'Telescope filetypes theme=get_ivy' end

-- match icons with the ones in the signs column
local diagnostics_component = components.diagnostics
diagnostics_component.symbols.error = lvim.icons.diagnostics.Error .. ' '
diagnostics_component.symbols.hint = lvim.icons.diagnostics.Hint .. ' '
diagnostics_component.symbols.info = lvim.icons.diagnostics.Information .. ' '
diagnostics_component.symbols.warn = lvim.icons.diagnostics.Warning .. ' '
diagnostics_component.on_click = function() vim.cmd 'Telescope diagnostics bufnr=0 theme=get_ivy' end

local lsp_component = {
  -- remove null_ls from lsp clients, adjust formatting
  ---@param message string
  ---@return string
  function(message)
    local buf_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
    if buf_clients and next(buf_clients) == nil then
      if type(message) == 'boolean' or #message == 0 then return '' end
      return message
    end

    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= 'null-ls' then table.insert(buf_client_names, client.name) end
    end

    buf_client_names = vim.fn.uniq(buf_client_names) ---@diagnostic disable-line missing-parameter

    -- no longer needed with full width statusbar
    -- if vim.fn.winwidth(0) < 150 and #(buf_client_names) > 1 then return #(buf_client_names) end

    local number_to_show = 1
    local first_few = vim.list_slice(buf_client_names, 1, number_to_show)
    local extra_count = #(buf_client_names) - number_to_show
    local output = table.concat(first_few, ', ')
    if extra_count > 0 then output = output .. ' +' .. extra_count end
    return output
  end,
  icon = { 'ʪ', color = { fg = require 'lvim.core.lualine.colors'.blue } },
  color = { gui = 'None' },
  on_click = function() vim.cmd 'LspInfo' end,
}

local codeium_status_component = {
  ---@return string
  function(_) return '' end,
  separator = { right = '' },
  color = function()
    local installed, _ = pcall(vim.cmd, 'Codeium')
    if not installed then return {} end

    local color
    if vim.fn['codeium#Enabled']() then
      color = require 'lvim.core.lualine.colors'.green
    else
      color = require 'lvim.core.lualine.colors'.red
    end

    return { fg = color }
  end,
  cond = function()
    local success, _ = pcall(vim.cmd, 'Codeium')
    return success
  end,
  on_click = function()
    if vim.fn['codeium#Enabled']() then
      vim.cmd 'CodeiumDisable'
    else
      vim.cmd 'CodeiumEnable'
    end
  end,
}

local codeium_component = {
  ---@return string
  function(_)
    local response = vim.fn['codeium#GetStatusString']()
    response = vim.trim(response)
    if response == 'ON' or response == 'OFF' then return '' end
    return response
  end,
  padding = { left = 0, right = 1 },
  cond = function()
    local installed, _ = pcall(vim.cmd, 'Codeium')
    return installed
  end,
}

local null_ls_component = {
  ---@param message string
  ---@return string
  function(message)
    local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
    if buf_clients and next(buf_clients) == nil then
      if type(message) == 'boolean' or #message == 0 then return '' end
      return message
    end
    local buf_client_names = {}

    if is_installed('null-ls') then
      for _, source in pairs(require 'null-ls.sources'.get_available(vim.bo.filetype)) do
        table.insert(buf_client_names, source.name)
      end
    end

    -- no longer needed with full width statusbar
    -- if vim.fn.winwidth(0) < 150 and #(buf_client_names) > 1 then return #(buf_client_names) end

    local number_to_show = 1
    local first_few = vim.list_slice(buf_client_names, 1, number_to_show)
    local extra_count = #(buf_client_names) - number_to_show
    local output = table.concat(first_few, ', ')
    if extra_count > 0 then output = output .. ' +' .. extra_count end
    return output
  end,
  color = { gui = 'None' --[[, fg = require"lvim.core.lualine.colors".purple]] },
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.purple } },
  cond = function() return is_installed 'null-ls' and require 'lvim.core.lualine.conditions'.hide_in_width() end,
  on_click = function() require 'null-ls.info'.show_window { border = 'rounded' } end,
}

local cmp_component = {
  ---@param _ string
  ---@return string
  function(_)
    local is_cmp_installed, cmp = pcall(require, 'cmp')
    if not is_cmp_installed then return '' end
    local config = require 'cmp.config'
    local sources = {}

    for _, s in pairs(cmp.core.sources) do
      if config.get_source_config(s.name) then
        if s:is_available() then
          table.insert(sources, s:get_debug_name())
        end
      end
    end

    local number_to_show = 1
    local first_few = vim.list_slice(sources, 1, number_to_show)
    local extra_count = #(sources) - number_to_show
    local output = table.concat(first_few, ', ')
    if extra_count > 0 then output = output .. ' +' .. extra_count end
    return output
  end,
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.green } },
  cond = function() return is_installed 'cmp' and require 'lvim.core.lualine.conditions'.hide_in_width() end,
  on_click = function() vim.cmd 'CmpStatus' end,
}

---@return string
local dap_component = {
  function()
    local is_dap_installed, dap = pcall(require, 'dap')
    if is_dap_installed then return dap.status() else return '' end
  end,
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.yellow } },
  cond = function()
    local is_dap_installed, dap = pcall(require, 'dap')
    return is_dap_installed and dap.status ~= ''
  end,
}

---@return string
local ale_linters_and_fixers_component = {
  function()
    local filetype = vim.bo.filetype
    if filetype == '' then return '' end
    local is_ale_installed, linter_details = pcall(vim.call, 'ale#linter#Get', filetype)
    if not is_ale_installed then return '' end

    ---@type table<integer, string>
    local ale_linters = vim.tbl_map(function(linter) return linter.name end, linter_details) ---@diagnostic disable-line assign-mismatch
    ---@type table<integer, string>
    local ale_fixers = vim.tbl_flatten({
      (vim.g['ale_fixers'] or {})[filetype] or {},
      vim.b[vim.api.nvim_get_current_buf()].ale_fixers or {},
    })
    ---@type table<integer, string>
    local linters_and_fixers = vim.tbl_flatten({ ale_linters, ale_fixers })
    if #(linters_and_fixers) == 0 then return '' end

    local output = table.remove(linters_and_fixers, 1)
    if #(linters_and_fixers) > 0 then output = output .. ' +' .. #(linters_and_fixers) end

    local is_ale_checking_buffer = vim.call('ale#engine#IsCheckingBuffer', vim.call('bufnr', ''))
    if is_ale_checking_buffer == 1 then output = output .. ' …' end

    return output
  end,
  -- color = { gui = 'None', fg = require'lvim.core.lualine.colors'.magenta },
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.violet } },
  on_click = function() vim.cmd 'ALEInfo' end,
}

lvim.builtin.lualine.sections.lualine_x = {
  diagnostics_component,
  lsp_component,
  ale_linters_and_fixers_component,
  null_ls_component,
  cmp_component,
}
-- lvim.builtin.lualine.sections.lualine_y = {}
-- lvim.builtin.lualine.sections.lualine_z = {}
-- lvim.builtin.lualine.sections.lualine_a = {}

-- components.branch.on_click = function() vim.cmd 'Git' end
-- components.branch.color = { gui = 'None' }

-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict ---@diagnostic disable-line undefined-field
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

components.diff.source = diff_source
components.diff.cond = function() return require 'lvim.core.lualine.conditions'.hide_in_width() end

lvim.builtin.lualine.sections.lualine_b = {
  -- components.branch,
  {
    'branch',
    icon = { lvim.icons.git.Branch },
    on_click = function() vim.cmd 'Git' end,
  },
}

components.spaces.separator = nil
components.spaces.cond = function() return require 'lvim.core.lualine.conditions'.hide_in_width() end

components.treesitter.on_click = function() vim.cmd 'TSInstallInfo' end -- doesn't work right

local current_session_component = {
  function()
    local session_name, _ = vim.v.this_session:gsub('^(.*/)(.*)$', '%2')
    return session_name
  end,
  cond = function() return vim.v.this_session ~= nil end,
  icon = { lvim.icons.ui.BookMark, color = { fg = require 'lvim.core.lualine.colors'.cyan } },
}

-- lualine builtin is not working for some reason
local search_count_component = {
  function()
    if vim.v.hlsearch == 0 then
      return ''
    end

    local result = vim.fn.searchcount { maxcount = 999, timeout = 500 }
    local denominator = math.min(result.total, result.maxcount)
    return string.format('[%d/%d]', result.current, denominator)
  end,
  { icon = { lvim.icons.ui.Search } },
}

local macro_component = {
  function()
    if vim.fn.reg_recording() == '' then return '' end
    return 'Recording: ' .. vim.fn.reg_recording()
  end,
  icon = { lvim.icons.ui.Circle, color = { fg = require 'lvim.core.lualine.colors'.red, gui = 'Bold' } },
  cond = function()
    return vim.fn.reg_recording() ~= '' and require 'lvim.core.lualine.conditions'.hide_in_width()
  end,
}

lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  components.filetype,
  components.treesitter,
  current_session_component,
  components.spaces,
  dap_component,
  search_count_component, -- useful for cmdheight=0
  macro_component,
  codeium_status_component,
  codeium_component,
}

-- }}}

-- luasnip {{{
lvim.builtin.luasnip.build = "make install_jsregexp" -- TODO this doesn't work
-- lvim.builtin.luasnip.update_events = { "TextChanged", "TextChangedI" } -- also not working
if is_installed('luasnip') then
  -- show transformations while you type
  require 'luasnip'.config.setup {
    update_events = { "TextChanged", "TextChangedI" },
  }
  -- strangely these aren't mapped by LunarVim. Doesn't work with noremap... i think because it's already mapped by something else
  vim.keymap.set('i', '<C-E>', '<Plug>luasnip-next-choice', {})
  vim.keymap.set('s', '<C-E>', '<Plug>luasnip-next-choice', {})
end
-- }}}

-- mason.nvim {{{
lvim.builtin.mason.ui.border = 'rounded'
-- lvim.builtin.mason.log_level = vim.log.levels.DEBUG
lvim.builtin.mason.ui.icons = {
  package_installed = lvim.icons.ui.Check,
  package_pending = lvim.icons.ui.BoldArrowRight,
  package_uninstalled = lvim.icons.ui.Close,
}
-- }}}

-- nvim-cmp {{{

lvim.builtin.cmp.cmdline.enable = true

-- table.insert(lvim.builtin.cmp.cmdline.options[2].sources, { name = 'nvim_lsp_document_symbol' })

-- lvim.builtin.cmp.experimental.ghost_text = true

lvim.builtin.cmp.formatting.source_names['buffer'] = ''
lvim.builtin.cmp.formatting.source_names['buffer-lines'] = '≡'
lvim.builtin.cmp.formatting.source_names['calc'] = ''
lvim.builtin.cmp.formatting.source_names['cmp_jira'] = ''
lvim.builtin.cmp.formatting.source_names['cmp_tabnine'] = '󰚩' --  ➒
lvim.builtin.cmp.formatting.source_names['color_names'] = ''
lvim.builtin.cmp.formatting.source_names["copilot"] = ""
lvim.builtin.cmp.formatting.source_names['dap'] = ''
lvim.builtin.cmp.formatting.source_names['dictionary'] = ''
lvim.builtin.cmp.formatting.source_names['doxygen'] = '' -- 󰙆
lvim.builtin.cmp.formatting.source_names['emoji'] = '' -- 
lvim.builtin.cmp.formatting.source_names['git'] = ''
lvim.builtin.cmp.formatting.source_names['jira_issues'] = ''
lvim.builtin.cmp.formatting.source_names['luasnip'] = '✄'
lvim.builtin.cmp.formatting.source_names['luasnip_choice'] = ''
lvim.builtin.cmp.formatting.source_names['marksman'] = '󰓾' -- 🞋
lvim.builtin.cmp.formatting.source_names['nerdfont'] = '󰬴'
lvim.builtin.cmp.formatting.source_names['nvim_lsp'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_document_symbol'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_signature_help'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lua'] = ''
lvim.builtin.cmp.formatting.source_names['path'] = '󰉋' --  
lvim.builtin.cmp.formatting.source_names['plugins'] = '' --  
lvim.builtin.cmp.formatting.source_names['rg'] = ''
lvim.builtin.cmp.formatting.source_names['tmux'] = ''
lvim.builtin.cmp.formatting.source_names['treesitter'] = ''
lvim.builtin.cmp.formatting.source_names['vsnip'] = '✄'
lvim.builtin.cmp.formatting.source_names['zk'] = ''

lvim.builtin.cmp.formatting.kind_icons.Method = lvim.icons.kind.Method -- default is 
lvim.builtin.cmp.formatting.kind_icons.Function = lvim.icons.kind.Function -- default is ƒ

local is_cmp_installed, cmp = pcall(require, 'cmp')
if is_cmp_installed then lvim.builtin.cmp.preselect = cmp.PreselectMode.None end
lvim.builtin.cmp.mapping['<C-J>'] = lvim.builtin.cmp.mapping['<Tab>']
lvim.builtin.cmp.mapping['<C-K>'] = lvim.builtin.cmp.mapping['<S-Tab>']

-- lvim.builtin.cmp.mapping['<C-Y>'] = function() require 'cmp'.mapping.confirm({ select = false }) end -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
-- }}}

-- null-ls / none-ls {{{
lvim.lsp.null_ls.setup.debounce = 1000
lvim.lsp.null_ls.setup.default_timeout = 30000
local is_null_ls_installed, null_ls = pcall(require, 'null-ls') ---@diagnostic disable-line redefined-local
-- lvim.lsp.null_ls.setup.debug = true -- turn on debug null-ls logging: tail -f ~/.cache/nvim/null-ls.log

-- linters {{{

require 'lvim.lsp.null-ls.linters'.setup {
  -- {
  --   name = 'codespell',
  --   -- force the severity to be HINT
  --   diagnostics_postprocess = function(diagnostic)
  --     diagnostic.severity = vim.diagnostic.severity.HINT
  --   end,
  --   extra_args = { '--ignore-words-list', 'tabe,noice' },
  -- },
  {
    name = 'cspell',
    filetypes = {
      'php',
      'python',
      'ruby',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    -- force the severity to be HINT
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity.HINT
    end,
  },
  -- { name = 'mypy', condition = function() return vim.fn.executable 'mypy' == 1 end }, -- disabled for ruff instead
  -- { name = 'pycodestyle', condition = function() return vim.fn.executable 'pycodestyle' == 1 end }, -- disabled for ruff instead
  -- { name = 'dotenv_linter' }, -- not available in Mason
  -- { name = 'luacheck' },
  { name = 'eslint_d' }, -- until I can get the eslint-lsp to work again
  -- { name = 'todo_comments' },
  { name = 'gitlint' },
  { name = 'semgrep' },
  { name = 'editorconfig_checker', filetypes = { 'editorconfig' } },
  -- { name = 'checkmake' }, -- makefile linter
  -- moved to ALE to avoid zombie process
  -- {
  --   name = 'phpcs',
  --   timeout = 30000,
  --   extra_args = {
  --     '--cache',
  --     '--warning-severity=3',
  --     '-d',
  --     'memory_limit=100M',
  --     -- '-d',
  --     -- 'xebug.mode=off',
  --   },
  --   condition = function(utils)
  --     return vim.fn.executable 'phpcs' == 1 and utils.root_has_file { 'phpcs.xml' }
  --   end,
  -- },
  -- moved to ALE to avoid zombie process
  -- {
  --   name = 'phpstan',
  --   timeout = 30000,
  --   extra_args = {
  --     '--memory-limit=200M',
  --     '--level=9', -- force level 9 for better editor intel
  --   }, -- 40MB is not enough
  --   condition = function(utils)
  --     return utils.root_has_file { 'phpstan.neon' }
  --   end,
  -- },
  { name = 'php' },
  -- { name = 'rubocop' },
  -- { name = 'spectral' },
  {
    name = 'shellcheck',
    condition = function() return not vim.tbl_contains({'.env', '.env.example'}, vim.fn.expand('%:t')) end,
  },
  { name = 'sqlfluff', extra_args = { '--dialect', 'mysql' } },
  { name = 'trail_space' },
  -- { name = 'vacuum' }, -- openapi linter. Much simpler and more stable than spectral.
  { name = 'zsh' },
}

-- local did_register_spectral
-- if is_null_ls_installed and not did_register_spectral then
--   null_ls.register { sources = {
--     null_ls.builtins.diagnostics.spectral.with {
--       command = { 'npx', '@stoplight/spectral-cli' }, -- damn it... LunarVim overrides the command now. Gotta do it from null-ls instead.
--       condition = function(utils) return utils.root_has_file { '.spectral.yaml' } end,
--     }
--   } }
--   did_register_spectral = true
-- end

-- }}}

-- formatters {{{
require 'lvim.lsp.null-ls.formatters'.setup {
  { name = 'black' },
  { name = 'eslint_d' }, -- until I can get the eslint-lsp to start working again
  { name = 'isort' },
  { name = 'blade_formatter' },
  { name = 'cbfmt' }, -- for formatting code blocks inside markdown and org documents
  { name = 'shfmt' },
  { name = 'json_tool', extra_args = { '--indent=2' } },
  -- { name = 'stylua' }, -- config doesn't seem to be working, even global
  -- moved to null-ls setup directly because lunarvim won't let me change the command
  -- {
  --   name = 'phpcbf',
  --   command = vim.env.HOME .. '/.support/phpcbf-helper.sh', -- damn it... they override the command now. Gotta do it from null-ls instead. https://github.com/lunarvim/lunarvim/blob/c18cd3f0a89443d4265f6df8ce12fb89d627f09e/lua/lvim/lsp/null-ls/services.lua#L81
  --   extra_args = { '-d', 'memory_limit=60M', '-d', 'xdebug.mode=off', '--warning-severity=0' }, -- do not fix warnings
  --   -- timeout = 20000,
  --   condition = function(utils)
  --     return vim.fn.executable 'phpcbf' == 1 and utils.root_has_file { 'phpcs.xml' }
  --   end,
  -- },
  {
    name = 'phpcsfixer',
    extra_args = { '--config=.php-cs-fixer.php' },
    timeout = 20000,
    condition = function(utils)
      -- return vim.fn.executable 'php-cs-fixer' == 1 and vim.fn.filereadable '.php-cs-fixer.php' == 1
      return utils.root_has_file { '.php-cs-fixer.php' }
    end,
  },
  { name = 'prettier' }, -- had problems with prettierd for some reason
  {
    name = 'rustywind', -- organizes tailwind classes
    condition = function(utils)
      -- return vim.fn.executable 'rustywind' == 1 and vim.fn.filereadable 'tailwind.config.js' == 1
      return utils.root_has_file { 'tailwind.config.js' }
    end
  },
  -- { name = 'sql_formatter', condition = function() return vim.fn.executable 'sql-formatter' == 1 end }, -- mangles variables
  {
    name = 'sqlfluff',
    extra_args = { '--dialect', 'mysql' },
    condition = function() return vim.fn.executable('sqlfluff') == 1 end,
  },
  -- -- { name = 'trim_newlines' },
  -- { name = 'trim_whitespace' },
}

local did_register_phpcbf
if is_null_ls_installed and not did_register_phpcbf then
  null_ls.register { sources = {
    null_ls.builtins.formatting.phpcbf.with {
      command = vim.env.HOME .. '/.support/phpcbf-helper.sh', -- damn it... LunarVim overrides the command now. Gotta do it from null-ls instead.
      extra_args = { '-d', 'memory_limit=60M', '-d', 'xdebug.mode=off', '-w', '--warning-severity=3' },
      -- condition = function()
      --   -- return utils.is_exectuable 'phpcbf' and utils.root_has_file { 'phpcs.xml' }
      --   return vim.fn.executable 'phpcbf' == 1 and vim.fn.filereadable 'phpcs.xml' == 1
      -- end,
    }
  } } -- @diagnostic disable-line redundant-parameter
  did_register_phpcbf = true
end

-- code actions {{{
require 'lvim.lsp.null-ls.code_actions'.setup {
  { name = 'cspell' },
  { name = 'eslint_d' }, -- until I can get eslint-lsp to start working
  { name = 'gitrebase' }, -- just provides helpers to switch pick to fixup, etc.
  -- adds a LOT of null-ls noise, not that useful
  {
    name = 'gitsigns',
    condition = function() return is_installed 'gitsigns' end,
    config = { filter_actions = function(title) return title:lower():match("blame") == nil end },
  },
  { name = 'refactoring' },
  -- { name = 'proselint' }, -- trying this out for markdown
  -- { name = 'ts_node_action' },
}
-- }}}

-- completion {{{
local did_register_spell
if is_null_ls_installed and not did_register_spell then
  null_ls.register { sources = {
    null_ls.builtins.completion.spell.with {
      filetypes = { 'markdown' },
      runtime_condition = function() return vim.wo.spell end,
    }
  } }
  did_register_spell = true
end ---@diagnostic disable-line redundant-parameter
-- }}}

-- hover {{{
local did_register_printenv
if is_null_ls_installed and not did_register_printenv then
  null_ls.register { sources = { null_ls.builtins.hover.printenv } }
  did_register_printenv = true
end
-- }}}

-- }}}

-- }}}

-- nvim-dap {{{
-- require 'dap'.set_log_level('DEBUG') -- debug dap: tail -f ~/.cache/nvim/dap.log

vim.api.nvim_create_augroup('dap_attach', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  group = 'dap_attach',
  callback = function() require 'dap.ext.autocompl'.attach() end,
})

local register_dap_adapters = function()
  local dap = require 'dap'
  dap.adapters.php = {
    type = 'executable',
    command = 'php-debug-adapter', -- this calls the same thing below
    -- command = 'node',
    -- args = { mason_path .. '/packages/php-debug-adapter/extension/out/phpDebug.js' },
  }

  -- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
  dap.adapters['pwa-node'] = {
    -- type = 'executable',
    -- command = 'js-debug-adapter ${port}',
    type = 'server',
    -- host = 'localhost',
    host = '0.0.0.0',
    -- host = '127.0.0.1',
    -- host = '${address}',
    port = 9229,
    -- port = '{port}',
    executable = {
      command = 'js-debug-adapter',
      -- command = mason_path .. '/bin/js-debug-adapter',
      args = { "${port}" },
      -- command = "node",
      -- args = { mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }

  -- dap.adapters.node2 = {
  --   type = 'executable',
  --   command = 'node2-debug-adapter', -- this calls the same thing below
  --   -- command = 'node',
  --   -- args = { mason_path .. '/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  -- }
end

local adjust_dap_signs = function()
  -- vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'debugPC', linehl = 'debugPC', numhl = 'debugPC' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
  -- vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'debugBreakpoint', linehl = 'debugBreakpoint', numhl = 'debugBreakpoint' })
end

local clear_dap_virtual_text = function(_, _)
  local ok, virtual_text = pcall(require, 'nvim-dap-virtual-text.virtual_text')
  if not ok then return end
  virtual_text.clear_virtual_text()
end

local close_dap_ui = function()
  local ok, dapui = pcall(require, 'dapui')
  if not ok then return end
  dapui.close({ reset = true })
end

local register_event_listeners = function()
  require 'dap'.listeners.after['event_terminated']['clear_virtual_text'] = clear_dap_virtual_text
  require 'dap'.listeners.after['event_exited']['clear_virtual_text'] = clear_dap_virtual_text
  require 'dap'.listeners.after['disconnect']['clear_virtual_text'] = clear_dap_virtual_text
  -- require 'dap'.listeners.after['event_stopped']['clear_virtual_text'] = clear_dap_virtual_text

  require 'dap'.listeners.after['event_initialized']['open_dapui'] = function()
    local ok, dapui = pcall(require, 'dapui')
    if not ok then return end
    dapui.open()
  end
  require 'dap'.listeners.after['event_terminated']['close_dapui'] = close_dap_ui
  require 'dap'.listeners.after['event_exited']['close_dapui'] = close_dap_ui
  require 'dap'.listeners.after['disconnect']['close_dapui'] = close_dap_ui
end

lvim.builtin.dap.on_config_done = function()
  register_dap_adapters()
  adjust_dap_signs()
  register_event_listeners()
end

require 'saatchiart.plugin_configs'.configure_nvim_dap()

-- }}}

-- nvim-navic {{{
-- https://github.com/SmiteshP/nvim-navic#%EF%B8%8F-setup
vim.g.navic_silence = true
-- lvim.builtin.breadcrumbs.options.separator = ' ' .. lvim.icons.ui.ChevronShortRight .. ' ' -- bug: this is only used for the _second_ separator and beyond https://github.com/LunarVim/LunarVim/blob/ea9b648a52de652a972471083f1e1d67f03305fa/lua/lvim/core/breadcrumbs.lua#L160
-- }}}

-- nvim-tree {{{

-- https://github.com/nvim-tree/nvim-tree.lua/issues/674
lvim.builtin.nvimtree.hide_dotfiles = nil
lvim.builtin.nvimtree.ignore = nil
lvim.builtin.nvimtree.git = {
  enable = true,
  ignore = true,
}

lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.unstaged = lvim.icons.git.FileUnstaged
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.untracked = lvim.icons.git.FileUntracked
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.staged = lvim.icons.git.FileStaged

lvim.builtin.nvimtree.setup.disable_netrw = true
lvim.builtin.nvimtree.setup.hijack_netrw = true

-- match lsp icons
lvim.builtin.nvimtree.setup.diagnostics.icons = {
  error = lvim.icons.diagnostics.Error,
  hint = lvim.icons.diagnostics.Hint,
  info = lvim.icons.diagnostics.Information,
  warning = lvim.icons.diagnostics.Warning,
}

if not vim.tbl_contains(lvim.builtin.nvimtree.setup.filters.custom, '\\.git') then table.insert(lvim.builtin.nvimtree.setup.filters.custom, '\\.git') end
if not vim.tbl_contains(lvim.builtin.nvimtree.setup.filters.custom, '\\.null-ls*') then table.insert(lvim.builtin.nvimtree.setup.filters.custom, '\\.null-ls*') end
-- }}}

-- nvim-treesitter {{{
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { 'php' } -- needed to make non-treesitter indent work

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
  -- if not is_installed('which-key') then return end
  -- require 'which-key'.register({
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

-- }}}

-- project.nvim {{{
if not vim.tbl_contains(lvim.builtin.project.patterns, 'composer.json') then table.insert(lvim.builtin.project.patterns, 'composer.json') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'config.lua') then table.insert(lvim.builtin.project.patterns, 'config.lua') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'bootstrap') then table.insert(lvim.builtin.project.patterns, 'bootstrap') end
-- }}}

-- telescope.nvim {{{

lvim.builtin.telescope.defaults.prompt_prefix = ' ' .. lvim.icons.ui.Search .. ' ' -- ⌕ 
lvim.builtin.telescope.defaults.winblend = vim.o.winblend -- pseudo-transparency
lvim.builtin.telescope.defaults.mappings.i['<Esc>'] = lvim.builtin.telescope.defaults.mappings.i['<C-c>'] -- disable normal mode

lvim.builtin.telescope.defaults.preview = { timeout = 1500 } -- default is 250 :/

lvim.builtin.telescope.on_config_done = function()
  -- https://github.com/LunarVim/LunarVim/issues/2374#issuecomment-1079453881
  local actions = require 'telescope.actions'
  lvim.builtin.telescope.defaults.mappings.i['<CR>'] = actions.select_default

  ---@return nil
  local grep_string = function()
    local default = vim.api.nvim_eval([[expand("<cword>")]])
    vim.ui.input({
      prompt = 'Search for: ',
      default = default,
    }, function(input)
      require('telescope.builtin').grep_string({ search = input })
    end)
  end

  lvim.builtin.which_key.mappings.s['i'] = { grep_string, 'Text From Input' }

  -- default is git_files (only already tracked) if in a git project, I don't like that
  lvim.builtin.which_key.mappings['f'] = { function() require('telescope.builtin').find_files {} end, 'Find File' }

  -- flip these mappings - lunarvim defaults are counter-intuitive
  lvim.builtin.telescope.defaults.mappings.i['<C-n>'] = actions.cycle_history_next
  lvim.builtin.telescope.defaults.mappings.i['<C-p>'] = actions.cycle_history_prev

  lvim.builtin.telescope.defaults.mappings.i['<C-j>'] = actions.move_selection_next
  lvim.builtin.telescope.defaults.mappings.i['<C-k>'] = actions.move_selection_previous

  vim.api.nvim_create_augroup('telescope_no_cmp', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = 'telescope_no_cmp',
    pattern = 'TelescopePrompt',
    callback = function()
      require 'cmp'.setup.buffer { enabled = false }
    end
  })
end
-- }}}

-- toggle-term.nvim {{{
lvim.builtin.terminal.execs = { { 'tig status', '<Leader>gg', 'Tig', 'float' } }
-- }}}

-- tokyonight.nvim {{{

lvim.colorscheme = 'tokyonight'
lvim.builtin.lualine.options.theme = 'tokyonight'
lvim.builtin.theme.name = 'tokyonight'
-- lvim.builtin.theme.tokyonight.options.style = 'storm'
-- lvim.builtin.theme.tokyonight.options.style = 'moon'
lvim.builtin.theme.tokyonight.options.style = 'night'

lvim.builtin.theme.tokyonight.options.dim_inactive = true -- dim inactive windows
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- bold headers for each section header
lvim.builtin.theme.tokyonight.options.sidebars = { 'NvimTree', 'aerial', 'Outline', 'DapSidebar', 'UltestSummary', 'dap-repl' }
-- lvim.builtin.theme.tokyonight.options.day_brightness = 0.05 -- high contrast
lvim.builtin.theme.tokyonight.options.day_brightness = 0.15 -- high contrast but colorful
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- section headers in lualine theme will be bold
lvim.builtin.theme.tokyonight.options.hide_inactive_statusline = true
-- vim.cmd 'silent! hi! link TabLineFill BufferLineGroupSeparator' -- temp workaround to bufferline background issue

lvim.builtin.theme.tokyonight.options.on_highlights = function(hl, c)
  local util = require 'tokyonight.util'
  hl.Folded = {
    -- change the fold color to be more subtle in both night and day modes
    -- yes, the bg was set to an fg color in tokyonight
    bg = util.darken(c.fg_gutter, 0.1),
  }
  hl.ColorColumn = {
    -- higher contrast since I am trying xiyaowong/virtcolumn.nvim
    bg = util.lighten(c.black, 1.05),
  }
end
-- }}}

-- which-key.nvim {{{
-- lvim.builtin.which_key.opts.nowait = false
-- lvim.builtin.which_key.vopts.nowait = false
lvim.builtin.which_key.setup.icons.group = ' '
lvim.builtin.which_key.setup.window.border = 'rounded'
lvim.builtin.which_key.setup.window.winblend = 15
-- see mappings for lvim.builtin.which_key.on_config_done

lvim.builtin.which_key.setup.plugins.marks = true
lvim.builtin.which_key.setup.plugins.registers = true

lvim.builtin.which_key.setup.plugins.presets.g = true
lvim.builtin.which_key.setup.plugins.presets.motions = true
lvim.builtin.which_key.setup.plugins.presets.nav = true
lvim.builtin.which_key.setup.plugins.presets.operators = true
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.setup.plugins.presets.windows = true
lvim.builtin.which_key.setup.plugins.presets.z = true

-- }}}

-- }}}

-- }}}

-- additional plugin definitions {{{
local plugins = {}

-- ale {{{

-- Q: Why use ale and not null-ls?
--
-- A: I sometimes get zombie processes started upstream by null-ls. It seems
-- to kill parent tasks when they time out or something, but if those parent
-- tasks had spawned child tasks, those never get killed but still end up
-- taking memory indefinitely. This adds up to enough memory that it slows
-- down my machine significantly. I've had this problem with phpcs, phpstan,
-- even codespell. An annoying workaround is to occasionally
-- `kill -9 {parent_task_id}` on the parent task of the zombie prcesses,
-- but that's a pain in the ass.
--
-- If these problems get fixed I will definitely switch!! But until that
-- happens, ALE is more stable and less problematic for linting with phpcs
-- and phpstan. I've reproduced these problems on a vanilla lunarvim config.

plugins.ale = {
  'dense-analysis/ale',
  dependencies = 'folke/which-key.nvim',
  -- event = 'BufRead',
  config = function()
    vim.g.ale_use_neovim_diagnostics_api = true -- save so much bullshit https://github.com/dense-analysis/ale/pull/4135
    vim.g.ale_lint_delay = 50
    vim.g.ale_lint_on_filetype_changed = false
    vim.g.ale_floating_preview = false -- neovim floating window to preview errors. This combines ale_detail_to_floating_preview and ale_hover_to_floating_preview.
    vim.g.ale_sign_highlight_linenrs = false
    vim.g.ale_disable_lsp = true
    vim.g.ale_echo_cursor = false
    vim.g.ale_set_highlights = false
    vim.g.ale_set_loclist = false
    vim.g.ale_set_signs = false
    vim.g.ale_linters_explicit = true -- only use configured linters instead of everything

    vim.g.ale_linters = {
      php = {
        'phpcs',
        'phpstan',
      },
    }

    vim.g.ale_fixers = {
      php = {
        'phpcbf',
        -- 'php_cs_fixer', -- this is enabled conditionally in the php ftplugin
      },
    }

    vim.g.ale_php_phpcbf_executable = vim.env.HOME .. '/.support/phpcbf-helper.sh'
    vim.g.ale_php_phpcbf_use_global = true
    vim.g.ale_php_phpcs_options = '--warning-severity=3'
    vim.g.ale_php_phpstan_level = 9
    vim.g.ale_php_phpstan_memory_limit = '200M'

    require 'which-key'.register({
      l = {
        F = { function () vim.cmd('ALEFix') end, 'Fix with ALE' },
      }
    }, { prefix = '<Leader>' })
  end,
}

-- }}}

-- auto-dark-mode {{{

plugins.auto_dark_mode = {
  'f-person/auto-dark-mode.nvim',
  dependencies = 'tokyonight.nvim',
  config = function()
    require 'auto-dark-mode'.setup {
      set_dark_mode = function() vim.o.background = 'dark' end,
      set_light_mode = function() vim.o.background = 'light' end
    }
    require 'auto-dark-mode'.init()
  end,
}
-- }}}

-- backseat.nvim {{{
plugins.backseat_nvim = {
  'james1236/backseat.nvim',
  -- cmd = { 'Backseat', 'BackseatAsk', 'BackseatClear', 'BackseatClearLine' },
  opts = {
    openapi_api_key = vim.env.OPENAI_API_KEY,
    openai_model_id = 'gpt-3.5-turbo',
    -- openai_model_id = 'GPT-4',
    highlight = { icon = '' },
    additional_instruction = 'Respond as if you are Robert C. Martin',
  },
}
--}}}

--- ccc.nvim {{{
plugins.ccc_nvim = {
  'uga-rosa/ccc.nvim',
  ft = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'html',
    'css',
    'scss',
  },
}
--}}}

-- cmp-color-names.nvim {{{
plugins.cmp_color_names = {
  'nat-418/cmp-color-names.nvim',
  dependencies = { 'hrsh7th/nvim-cmp' },
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'color_names' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'color_names' })
  end,
}
-- }}}

-- cmp-copilot {{{
plugins.cmp_copilot = {
  "hrsh7th/cmp-copilot",
  dependencies = 'hrsh7th/nvim-cmp',
  config = function()
    table.insert(lvim.builtin.cmp.sources, 2, { name = "copilot" })
  end,
}
-- }}}

-- cmp-dap {{{
plugins.cmp_dap = {
  'rcarriga/cmp-dap',
  dependencies = {
    'rcarriga/cmp-dap',
    'hrsh7th/nvim-cmp',
  },
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'dap' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'dap' })
  end,
  config = function()
    require 'cmp'.setup.filetype { 'dap-repl', 'dapui_watches' }
  end,
}
-- }}}

-- cmp-dictionary {{{

plugins.cmp_dictionary = {
  'uga-rosa/cmp-dictionary',
  dependencies = { 'hrsh7th/nvim-cmp' },
  event = 'InsertEnter',
  init = function()
    local source = { name = 'dictionary', keyword_length = 2, max_item_count = 3 }
    if vim.tbl_contains(lvim.builtin.cmp.sources, source) then return end
    table.insert(lvim.builtin.cmp.sources, source)
  end,
  config = function()
    require 'cmp_dictionary'.setup { dic = { ['*'] = '/usr/share/dict/words' } }
  end,
}
-- }}}

-- cmp-emoji {{{

plugins.cmp_emoji = {
  'hrsh7th/cmp-emoji',
  event = 'InsertEnter',
  dependencies = 'hrsh7th/nvim-cmp',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'emoji' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'emoji' })
  end,
}
-- }}}

-- cmp-git {{{

-- expects GITHUB_API_TOKEN env var to be set
plugins.cmp_git = {
  'petertriho/cmp-git',
  ft = { 'gitcommit', 'octo', 'markdown' },
  dependencies = {
    'hrsh7th/nvim-cmp',
    'nvim-lua/plenary.nvim',
  },
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'git' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'git' })
  end,
  opts = { filetypes = { 'gitcommit', 'octo', 'markdown' } },
}
-- }}}

-- cmp-jira {{{
plugins.cmp_jira = {
  -- 'lttr/cmp-jira',
  'mikedfunk/cmp-jira', -- fork to use basic auth, which is apparently needed for Jira cloud
  event = 'InsertEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'cmp_jira' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'cmp_jira' })
  end,
  opts = {},
}
-- }}}

-- cmp-jira-issues.nvim {{{
plugins.cmp_jira_issues_nvim = {
  'artem-nefedov/cmp-jira-issues.nvim',
  event = 'InsertEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'jira_issues' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'jira_issues' })
  end,
  opts = {},
}
-- }}}

-- cmp-nerdfont {{{
plugins.cmp_nerdfont = {
  'chrisgrieser/cmp-nerdfont',
  event = 'InsertEnter',
  dependencies = 'hrsh7th/nvim-cmp',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'nerdfont' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'nerdfont' })
  end,
}
-- }}}

-- cmp-nvim-lsp-document-symbol {{{
local setup_cmp_nvim_lsp_document_symbol = function()
  local symbol_source = {
    sources = require 'cmp'.config.sources { { name = 'nvim_lsp_document_symbol', option = {} } },
    type = { '/' },
  }
  if vim.tbl_contains(lvim.builtin.cmp.cmdline.options, symbol_source) then return end

  local sources = { symbol_source }
  vim.list_extend(sources, lvim.builtin.cmp.cmdline.options) ---@diagnostic disable-line missing-parameter
  lvim.builtin.cmp.cmdline.options = sources
end

plugins.cmp_nvim_lsp_document_symbol = {
  'hrsh7th/cmp-nvim-lsp-document-symbol',
  dependencies = {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-cmdline',
  },
  -- event = 'InsertEnter',
  event = 'CmdlineEnter',
  init = setup_cmp_nvim_lsp_document_symbol
}
-- }}}

-- cmp-nvim-lsp-signature-help {{{

plugins.cmp_nvim_lsp_signature_help = {
  'hrsh7th/cmp-nvim-lsp-signature-help',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'nvim_lsp_signature_help' }) then return end
    table.insert(lvim.builtin.cmp.sources, {
      name = 'nvim_lsp_signature_help',
      -- preselect = require 'cmp'.PreselectMode.None,
    })
  end,
}
-- }}}

-- cmp-luasnip-choice {{{
plugins.cmp_luasnip_choice = {
  'doxnit/cmp-luasnip-choice',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  init = function()
    lvim.builtin.cmp.snippet.expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'luasnip_choice' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'luasnip_choice' })
  end,
  opts = {}
}
-- }}}

-- cmp-plugins {{{
plugins.cmp_plugins = {
  'KadoBOT/cmp-plugins',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'plugins' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'plugins' })
  end,
}
-- }}}

-- cmp-rg {{{

plugins.cmp_rg = {
  'lukas-reineke/cmp-rg',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  -- avoid running ripgrep on cwd for things like $HOME for dotfiles, etc. where
  -- it could be expensive
  cond = require 'saatchiart.plugin_configs'.cmp_rg_cond,
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'rg' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'rg' })
  end,
}
-- }}}

-- cmp-tabnine {{{

plugins.cmp_tabnine = {
  'tzachar/cmp-tabnine',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  build = './install.sh',
  cond = function()
    -- do not enable tabnine for dotfiles. It takes tons of CPU.
    local pwd = vim.api.nvim_exec('pwd', true)
    return pwd:match('/Code')
  end,
  init = function()
    if not vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'cmp_tabnine' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'cmp_tabnine' })
  end,
  config = function()
    require 'cmp_tabnine.config':setup {
      max_lines = 1000,
      max_num_results = 20,
      sort = true,
      ignored_file_types = {
        php = true, -- it's cool but LSP results are smarter, and if it's behind LSP results it's too far to scroll to see them :/
        phtml = true,
        html = true,
      },
    }

    -- make tabnine higher priority
    --
    -- local compare = require 'cmp.config.compare'
    -- require 'cmp'.setup {
    --   sorting = {
    --     priority_weight = 2,
    --     comparators = {
    --       require 'cmp_tabnine.compare',
    --       compare.offset,
    --       compare.exact,
    --       compare.score,
    --       compare.recently_used,
    --       compare.kind,
    --       compare.sort_text,
    --       compare.length,
    --       compare.order,
    --     },
    --   },
    -- }

    vim.api.nvim_create_augroup('tabnine_prefetch', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = 'tabnine_prefetch',
      pattern = 'php',
      callback = function()
        require 'cmp_tabnine':prefetch(vim.fn.expand('%:p'))
      end
    })
  end,
}
-- }}}

-- cmp-tmux {{{

plugins.cmp_tmux = {
  'andersevenrud/cmp-tmux',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  branch = 'main',
  init = function()
    local source = { name = 'tmux', option = { all_panes = true } }
    if vim.tbl_contains(lvim.builtin.cmp.sources, source) then return end
    table.insert(lvim.builtin.cmp.sources, source)
  end,
}
-- }}}

-- cmp-treesitter {{{

plugins.cmp_treesitter = {
  'ray-x/cmp-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp',
  },
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'treesitter' }) then return end
    table.insert(lvim.builtin.cmp.sources, { name = 'treesitter' })
  end,
}
-- }}}

-- codeium.vim {{{
plugins.codeium_vim = {
  'Exafunction/codeium.vim',
  dependencies = 'folke/which-key.nvim',
  event = 'BufEnter',
  init = function()
    vim.g.codeium_disable_bindings = 1
    lvim.builtin.which_key.mappings['l']['O'] = {
      function()
        if vim.fn['codeium#Enabled']() == true then
          vim.cmd 'CodeiumDisable'
        else
          vim.cmd 'CodeiumEnable'
        end
      end,
      'Toggle Codeium'
    }
  end,
  config = function()
    vim.keymap.set('i', '<m-tab>', vim.fn['codeium#Accept'], { noremap = true, expr = true, desc = 'Codeium Accept' })
    vim.keymap.set('i', '<m-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { noremap = true, expr = true, desc = 'Next Codeium Completion' })
    vim.keymap.set('i', '<m-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { noremap = true, expr = true, desc = 'Prev Codeium Completion' })
    vim.keymap.set('i', '<m-x>', vim.fn['codeium#Clear'], { noremap = true, expr = true, desc = 'Codeium Clear' })
    vim.keymap.set('i', '<m-i>', vim.fn['codeium#Complete'], { noremap = true, expr = true, desc = 'Codeium Complete' })
  end
}
-- }}}

-- copilot.vim {{{
plugins.copilot_vim = {
  "github/copilot.vim",
  event = "VeryLazy",
  config = function()
    -- copilot assume mapped
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_no_tab_map = true
  end,
}
-- }}}

-- dark-notify {{{
plugins.dark_notify = {
  'cormacrelf/dark-notify',
  config = function()
    require 'dark_notify'.run {
      onchange = function()
        vim.cmd 'silent! !tmux source ~/.config/tmux/tmux.conf &'
      end,
    }
  end
}
-- }}}

-- definition-or-references.nvim {{{
plugins.definition_or_references_nvim = {
  'KostkaBrukowa/definition-or-references.nvim',
  dependencies = 'folke/which-key.nvim',
  event = 'LspAttach',
  config = function()
    require 'which-key'.register({
      d = { function () require("definition-or-references").definition_or_references() end, 'Go to definition or references' },
    }, { prefix = 'g' })
  end,
  opts = {},
}
-- }}}

-- dial.nvim {{{

---@return nil
local configure_dial = function()
  local augend = require 'dial.augend'
  require 'dial.config'.augends:register_group {
    default = {
      augend.integer.alias.decimal,
      augend.constant.new { elements = {
        'private',
        'protected',
        'public',
      } },
      augend.constant.new { elements = {
        'string',
        'int',
        'bool',
        'float',
        'array',
      } },
      augend.constant.new { elements = {
        'self',
        'static',
      } },
      augend.constant.new { elements = {
        'TODO',
        'FIXME',
        'WARNING',
        'BUG',
        'NOTE',
      } },
      augend.constant.new { elements = {
        '@category entity',
        '@category value-object',
        '@category DTO',
        '@category top-level',
        '@internal should not be used as a top-level service',
      }, word = false },
      -- TODO not working
      -- augend.constant.new { elements = {
      --   '[ ]',
      --   '[X]',
      --   '[-]',
      --   '[~]',
      -- }, word = false },
      augend.integer.alias.hex,
      augend.constant.alias.bool,
      augend.date.alias['%Y-%m-%d'],
    },
  }

  vim.keymap.set('n', '<c-a>', require 'dial.map'.inc_normal(), { noremap = true })
  vim.keymap.set('n', '<c-x>', require 'dial.map'.dec_normal(), { noremap = true })

  vim.keymap.set('v', '<c-a>', require 'dial.map'.inc_visual(), { noremap = true })
  vim.keymap.set('v', '<c-x>', require 'dial.map'.dec_visual(), { noremap = true })

  vim.keymap.set('v', 'g<c-a>', require 'dial.map'.inc_gvisual(), { noremap = true })
  vim.keymap.set('v', 'g<c-x>', require 'dial.map'.dec_gvisual(), { noremap = true })
end

plugins.dial_nvim = {
  'monaqa/dial.nvim',
  event = 'BufRead',
  config = configure_dial,
}
-- }}}

-- document-color.nvim {{{
-- tailwind color previewing
plugins.document_color_nvim = { 'mrshmllow/document-color.nvim' }

plugins.document_color_nvim_on_attach = function(client, bufnr)
  if not is_installed('document-color') then return end
  if not client.server_capabilities.colorProvider then return end
  -- Attach document colour support
  require('document-color').buf_attach(bufnr)
end
-- }}}

-- dressing.nvim {{{
plugins.dressing_nvim = {
  'stevearc/dressing.nvim',
  event = 'BufReadPre',
  opts = {
    input = {
      default_prompt = ' ', --  
    },
  },
}
-- }}}

-- edgy.nvim {{{
plugins.edgy_nvim = {
  'folke/edgy.nvim',
  event = 'VeryLazy',
  opts = {
    left = {
      {
        title = 'Explorer',
        ft = 'NvimTree',
        open = 'NvimTreeFindFile',
        pinned = true,
        size = { height = 0.7 }
      },
      {
        title = 'Symbols',
        ft = 'Outline',
        open = 'SymbolsOutlineOpen',
        pinned = true,
        size = { height = 0.3 }
      },
      {
        title = 'UndoTree',
        ft = 'undotree',
        open = 'UndotreeShow',
        -- pinned = true,
        -- size = { height = 1 }
      }
    },
    bottom = {
      -- {
      --   title = 'Debugger REPL',
      --   ft = 'dap-repl',
      --   -- open = 'DapToggleRepl',
      --   open = function() require 'dapui'.open(); require 'dap'.continue() end,
      -- },
      -- {
      --   title = 'Debugger Console',
      --   ft = 'dapui_console',
      --   open = function() require 'dapui'.open(); require 'dap'.continue() end,
      -- },
    },
    right = {
      -- {
      --   title = 'DAP Scopes',
      --   ft = 'dapui_scopes',
      --   open = function() require 'dapui'.open(); require 'dap'.continue() end,
      --   size = { width = 0.3 },
      -- },
      -- {
      --   title = 'DAP Breakpoints',
      --   ft = 'dapui_breakpoints',
      --   open = function() require 'dapui'.open(); require 'dap'.continue() end,
      --   size = { width = 0.3 },
      -- },
      -- {
      --   title = 'DAP Stacks',
      --   ft = 'dapui_stacks',
      --   open = function() require 'dapui'.open(); require 'dap'.continue() end,
      --   size = { width = 0.3 },
      -- },
      -- {
      --   title = 'DAP Watches',
      --   ft = 'dapui_watches',
      --   open = function() require 'dapui'.open(); require 'dap'.continue() end,
      --   size = { width = 0.3 },
      -- },
    },
  }
}
-- }}}

-- fold-preview.nvim {{{
plugins.fold_preview_nvim = {
  'anuvyklack/fold-preview.nvim',
  dependencies = 'anuvyklack/keymap-amend.nvim',
  event = 'BufRead',
  -- ft = { 'lua', 'gitconfig', 'dosini' },
  opts = {
    auto = 400,
    border = 'rounded'
    -- default_keybindings = false,
  },
}

-- }}}

-- goto-breakpoints.nvim {{{
plugins.goto_breakpoints_nvim = {
  'ofirgall/goto-breakpoints.nvim',
  dependencies = 'folke/which-key.nvim',
  init = function()
    require 'which-key'.register({
      d = { function() require 'goto-breakpoints'.next() end, 'Go to Next Breakpoint' },
    }, { prefix = ']' })
    require 'which-key'.register({
      d = { function() require 'goto-breakpoints'.next() end, 'Go to Previous Breakpoint' },
    }, { prefix = '[' })
  end
}
-- }}}

-- headlines.nvim {{{
plugins.headlines_nvim = {
  'lukas-reineke/headlines.nvim',
  ft = 'markdown',
  opts = { markdown = { fat_headlines = false } },
}
-- }}}

-- incolla.nvim {{{
plugins.incolla_nvim = {
  'mattdibi/incolla.nvim',
  ft = 'markdown',
  init = function()
    lvim.builtin.which_key.mappings['m'] = lvim.builtin.which_key.mappings['m'] or { name = 'Markdown' }
    lvim.builtin.which_key.mappings['m']['p'] = {
      function() require 'incolla'.incolla() end,
      'Paste Image',
    }
  end,
}
-- }}}

-- laravel.nvim {{{
plugins.laravel_nvim = {
  "adalessa/laravel.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
  keys = {
    { "<leader>va", ":Laravel artisan<cr>" },
    { "<leader>vr", ":Laravel routes<cr>" },
    { "<leader>vm", ":Laravel related<cr>" },
    {
      "<leader>vt",
      function()
        require("laravel.tinker").send_to_tinker()
      end,
      mode = "v",
      desc = "Laravel Application Routes",
    },
  },
  event = { "VeryLazy" },
  config = function()
    require("laravel").setup {
      lsp_server = 'intelephense',
      environment = {
        resolver = require "laravel.environment.resolver"(true, true, 'local'),
      }
    }
    require("telescope").load_extension "laravel"
  end,
}
-- }}}

-- lsp-inlayhints.nvim {{{
plugins.lsp_inlayhints_nvim = {
  'lvimuser/lsp-inlayhints.nvim',
  opts = {}
}

---@param client table
---@param bufnr integer
---@return nil
plugins.lsp_inlayhints_on_attach = function(client, bufnr)
  local is_lsp_inlayhints_installed, lsp_inlayhints = pcall(require, 'lsp-inlayhints')
  if not is_lsp_inlayhints_installed then return end
  lsp_inlayhints.on_attach(client, bufnr)
  -- vim.cmd 'hi link LspInlayHint Comment'
end
-- }}}

-- LuaSnip {{{
-- not sure if this works
local luasnip_def = vim.tbl_filter(
  function (plugin)
    return plugin[1] == 'L3MON4D3/LuaSnip'
  end,
  require('lvim.plugins')
)[1]

luasnip_def.build = "make install_jsregexp"
plugins.luasnip = luasnip_def
-- }}}

-- mason-null-ls.nvim {{{
plugins.mason_null_ls_nvim = {
  'jayp0521/mason-null-ls.nvim',
  dependencies = {
    'null-ls.nvim',
    'mason.nvim',
  },
  opts = {
    -- automatic_setup = true, -- I use lunarvim's lsp module to do the same thing as this feature.
    automatic_installation = {
      -- which null-ls sources to use default PATH installation for (don't install with Mason)
      exclude = {
        'phpcs',
        'phpcbf',
        'mypy',
        'pycodestyle',
      },
    },
  },
}
-- }}}

-- mini-align {{{
plugins.mini_align = {
  'echasnovski/mini.align',
  event = 'BufRead',
  version = false,
  dependencies = 'folke/which-key.nvim',
  config = function()
    require 'which-key'.register({ a = 'Align operator right' }, { prefix = 'g' })
  end
}
-- }}}

-- mkdx {{{

---@return nil
local setup_mkdx = function()
  vim.g['mkdx#settings'] = {
    checkbox = { toggles = { ' ', '-', 'X' } },
    insert_indent_mappings = 1, -- <c-t> to indent, <c-d> to unindent
    -- highlight = { enable = true },
    links = { conceal = 1 },
    map = { prefix = '<leader>m' },
    -- tab = { enable = 0 },
  }
end

---@return nil
local configure_mkdx = function()
  vim.api.nvim_create_augroup('mkdx_map', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    group = 'mkdx_map',
    callback = function() vim.keymap.set('n', '<cr>', '<Plug>(mkdx-checkbox-prev-n)', { buffer = true, noremap = true }) end,
  })

  if not is_installed('which-key') then return end

  require 'which-key'.register({
    m = {
      name = 'Markdown',
      ["'"] = { name = 'Quote Toggle' },
      ['-'] = { name = '↓ Checkbox State' },
      ['<Leader>'] = { name = '↓ Checkbox State' },
      ['='] = { name = '↑ Checkbox State' },
      ['/'] = { name = 'Italic' },
      ['['] = { name = '↑ Header' },
      [']'] = { name = '↓ Header' },
      ['`'] = { name = 'Code Block' },
      b = { name = 'Bold' },
      I = { name = 'TOC Quickfix' },
      i = { name = 'TOC Upsert' },
      j = { name = 'Jump to Header' },
      k = { name = '<kbd>' },
      L = { name = 'Links Quickfix' },
      s = { name = 'Strikethrough' },
      t = { name = 'Checkbox Toggle' },
      l = {
        name = 'List',
        l = { name = 'List Toggle' },
        n = { name = 'Link Wrap' },
        t = { name = 'Checklist Toggle' },
      }
    }
  }, { prefix = '<Leader>' })

  require 'which-key'.register({
    m = {
      name = 'Markdown',
      ["'"] = { name = 'Quote Toggle' },
      ['-'] = { name = '↓ Checkbox State' },
      ['='] = { name = '↑ Checkbox State' },
      ['/'] = { name = 'Italic' },
      ['['] = { name = '↑ Header' },
      [']'] = { name = '↓ Header' },
      ['`'] = { name = 'Code Block' },
      [','] = { name = 'Tableize' },
      b = { name = 'Bold' },
      I = { name = 'TOC Quickfix' },
      i = { name = 'TOC Upsert' },
      j = { name = 'Jump to Header' },
      k = { name = '<kbd>' },
      L = { name = 'Links Quickfix' },
      s = { name = 'Strikethrough' },
      t = { name = 'Checkbox Toggle' },
      l = {
        name = 'List',
        l = { name = 'List Toggle' },
        n = { name = 'Link Wrap' },
        t = { name = 'Checklist Toggle' },
      }
    }
  }, { prefix = '<Leader>', mode = 'v' })
end

plugins.mkdx = {
  'SidOfc/mkdx',
  ft = 'markdown',
  -- dependencies = 'folke/which-key.nvim', -- this overrides ft... I think because which-key needs to be loaded _before_ something
  init = setup_mkdx,
  config = configure_mkdx,
}
-- }}}

-- modes.nvim {{{
plugins.modes_nvim = {
  'mvllow/modes.nvim',
  event = 'BufRead',
  dependencies = { 'folke/which-key.nvim' },
  init = function()
    -- https://github.com/mvllow/modes.nvim#known-issues
    lvim.builtin.which_key.setup.plugins.presets.operators = false
  end,
  opts = {
    ignored_filetypes = { 'startify' }
  },
}
-- }}}

-- neoai.nvim {{{
plugins.neoai_nvim = {
  'Bryley/neoai.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  cmd = {
    'NeoAI',
    'NeoAIOpen',
    'NeoAIClose',
    'NeoAIToggle',
    'NeoAIContext',
    'NeoAIContextOpen',
    'NeoAIContextClose',
    'NeoAIInject',
    'NeoAIInjectCode',
    'NeoAIInjectContext',
    'NeoAIInjectContextCode',
  },
  opts = {
    models = {
      {
        name = "openai",
        model = "gpt-3.5-turbo",
        -- model = "gpt-4",
        params = nil,
      },
    },
  },
}
-- }}}

-- neodim {{{
plugins.neodim = {
  'zbirenbaum/neodim',
  event = 'LspAttach',
  opts = {
    alpha = 0.5
  }
}
-- }}}

-- neoscroll.nvim {{{
plugins.neoscroll_nvim = {
  'karb94/neoscroll.nvim',
  dependencies = 'folke/which-key.nvim',
  keys = {
    '<C-u>',
    '<C-d>',
    '<C-f>',
    '<C-b>',
    'zz',
    'zt',
    'zb',
    'gg',
    'G',
  },
  config = function()
    require 'neoscroll'.setup { easing_function = 'cubic' }
    require 'which-key'.register({ g = { 'Go to top of file' } }, { prefix = 'g' })
  end,
}
-- }}}

-- NeoZoom.lua {{{
plugins.neo_zoom_lua = {
  'nyngwang/NeoZoom.lua',
  dependencies = 'folke/which-key.nvim',
  -- ft = { 'dapui_.*', 'dap-repl' },
  cmd = { 'NeoZoomToggle', 'NeoZoom' },
  init = function()
    require 'which-key'.register({
      z = {
        function() vim.cmd 'NeoZoomToggle' end,
        'Toggle Zoom',
      },
    }, { prefix = '<C-w>' })
  end,
  opts = {
    presets = {
      {
        filetypes = { 'dapui_.*', 'dap-repl' },
        config = {
          top_ratio = 0.25,
          left_ratio = 0.6,
          width_ratio = 0.4,
          height_ratio = 0.65,
        },
        -- callbacks = {
        --   function() vim.wo.wrap = true end,
        -- },
      },
    },
  }
}
-- }}}

-- noice.nvim {{{
plugins.noice_nvim = {
  'folke/noice.nvim',
  event = 'VimEnter',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
    'hrsh7th/nvim-cmp',
  }
}
-- }}}

-- notifier.nvim {{{
plugins.notifier_nvim = {
  'vigoux/notifier.nvim',
  event = 'BufRead',
  opts = {
    ignore_messages = {
      'codespell',
      'null-ls', -- ignores diagnostics_on_open, not sure why
    }, -- ignore messages _from LSP servers_ with this name
    notify = {
      clear_timer = 5000, -- default 5000
      min_level = vim.log.levels.WARN, -- default INFO (hide No information available)
    },
    -- component_name_recall = true, -- Whether to prefix the title of the notification by the component name (e.g. lsp:null-ls)
  },
}
-- }}}

-- numb.nvim {{{
plugins.numb_nvim = {
  'nacro90/numb.nvim',
  event = 'CmdlineEnter',
  opts = {
    show_numbers = true, -- Enable 'number' for the window while peeking
    show_cursorline = true, -- Enable 'cursorline' for the window while peeking
  },
}
-- }}}

-- nvim-bqf {{{

plugins.nvim_bqf = {
  'kevinhwang91/nvim-bqf',
  branch = 'main',
  event = 'BufRead',
  config = function() require 'bqf'.setup {
    should_preview_cb = function(bufnr, _)
      return vim.api.nvim_buf_get_option(bufnr, 'filetype') ~= 'git'
    end,
  } end,
  dependencies = 'nvim-treesitter/nvim-treesitter',
}
-- }}}

-- nvim_context_vt {{{

plugins.nvim_context_vt = {
  'haringsrob/nvim_context_vt',
  event = 'BufRead',
  opts = {
    ---@param node table
    ---@return string|nil
    custom_text_handler = function(node)
      if not is_installed 'nvim-treesitter/nvim-treesitter' then return nil end
      return '↩ ' .. vim.treesitter.get_node_text(node, 0)[1]
    end
  },
}
-- }}}

-- nvim-dap-tab {{{
plugins.nvim_dap_tab = {
  'przepompownia/nvim-dap-tab',
  -- ft = {
  --   'php',
  --   'javascript',
  --   'typescript',
  --   'javascriptreact',
  --   'typescriptreact',
  --   'ruby',
  --   'python',
  -- },
  dependencies = {
    'mfussenegger/nvim-dap',
    'folke/which-key.nvim',
    'rcarriga/nvim-dap-ui',
    'folke/which-key.nvim',

  },
  init = function()
    lvim.builtin.which_key.mappings['d']['T'] = { function() require 'dap-tab'.verboseGoToDebugWin() end, 'Open Debug Tab' }
    lvim.builtin.which_key.mappings['d']['X'] = { function() require 'dap-tab'.verboseGoToDebugWin() end, 'Close Debug Tab' }
  end,
  config = function() require 'dap-tab'.setup() end
}
-- }}}

-- nvim-dap-virtual-text {{{
plugins.nvim_dap_virtual_text = {
  'theHamsta/nvim-dap-virtual-text',
  ft = 'php',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    only_first_definition = false,
    all_references = true,
  },
}
-- }}}

-- nvim-Femaco.lua {{{
plugins.nvim_femaco_lua = {
  'AckslD/nvim-FeMaco.lua',
  ft = 'markdown',
  init = function()
    if is_installed('which-key') then
      require 'which-key'.register({
        m = {
          e = { function() require('femaco.edit').edit_code_block() end, 'Edit Code Block' },
        },
      }, { prefix = '<Leader>' })
    end
  end,
}
-- }}}

-- nvim-hlslens {{{
plugins.nvim_hlslens = {
  'kevinhwang91/nvim-hlslens',
  -- taken from minimal config https://github.com/kevinhwang91/nvim-hlslens#minimal-configuration
  config = function()
    require 'nvim-hlslens'.setup {
      -- calm_down = true,
      -- nearest_only = true,
    }
    vim.keymap.set('n', 'n',
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      { noremap = true, silent = true })
    vim.keymap.set('n', 'N',
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      { noremap = true, silent = true })
    vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], { noremap = true, silent = true })

    -- vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', kopts)
  end
}
-- }}}

-- nvim-lastplace {{{
plugins.nvim_lastplace = {
  'ethanholz/nvim-lastplace',
  event = 'BufRead',
  opts = {
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
    lastplace_open_folds = true,
  },
}
-- }}}

-- nvim-lightbulb {{{

---@return nil
plugins.nvim_lightbulb_on_attach = function()
  local is_nvim_lightbulb_installed, nvim_lightbulb = pcall(require, 'nvim-lightbulb')
  if not is_nvim_lightbulb_installed then return end
  -- vim.cmd "autocmd CursorHold,CursorHoldI * lua require 'nvim-lightbulb'.update_lightbulb{}"
  vim.api.nvim_create_augroup('nvim_lightbulb', { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    pattern = '*',
    group = 'nvim_lightbulb',
    desc = 'nvim lightbulb update',
    callback = function() nvim_lightbulb.update_lightbulb() end,
  })
end

plugins.nvim_lightbulb = {
  'kosayoda/nvim-lightbulb',
  -- init = function()
  --   vim.fn.sign_define('LightBulbSign', { text = '', texthl = 'DiagnosticSignWarn' })
  -- end,
  opts = {
    sign = {
      text = '',
      hl = 'DiagnosticSignWarn',
    }
  }
}
-- }}}

-- nvim-scrollbar {{{
plugins.nvim_scrollbar = {
  'petertriho/nvim-scrollbar',
  dependencies = {
    'folke/tokyonight.nvim',
    -- 'nvim-hlslens',
  },
  event = 'VimEnter',
  config = function()
    if is_installed 'hlslens' then require 'scrollbar.handlers.search'.setup() end -- for hlslens. doesn't seem to work :/
    -- local colors = require('tokyonight.colors').setup()

    require('scrollbar').setup({
      handle = {
        highlight = 'PmenuSel',
      },
      -- marks = {
      --   Cursor = { text = "" },
      -- },
      -- marks = {
      --   Search = { color = colors.orange }, -- doesn't seem to work :/
      -- },
      excluded_filetypes = {
        'DressingInput',
        'TelescopePrompt',
      },
    })
  end,
}
-- }}}

-- nvim-spider {{{
plugins.nvim_spider = {
  'chrisgrieser/nvim-spider',
  event = 'BufRead',
  config = function()
    vim.keymap.set({"n", "o", "x"}, "w", function() require("spider").motion("w") end, { desc = "Spider-w" })
    vim.keymap.set({"n", "o", "x"}, "e", function() require("spider").motion("e") end, { desc = "Spider-e" })
    vim.keymap.set({"n", "o", "x"}, "b", function() require("spider").motion("b") end, { desc = "Spider-b" })
    vim.keymap.set({"n", "o", "x"}, "ge", function() require("spider").motion("ge") end, { desc = "Spider-ge" })
  end
}
-- }}}

-- nvim-treesitter-endwise {{{
plugins.nvim_treesitter_endwise = {
  'RRethy/nvim-treesitter-endwise',
  -- event = 'BufRead',
  ft = {
    'ruby',
    'lua',
    'zsh',
    'bash',
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  init = function()
    lvim.builtin.treesitter.endwise = { enable = true }
  end,
}
-- }}}

-- nvim-treesitter-playground {{{
plugins.nvim_treesitter_playground = {
  'nvim-treesitter/playground',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  init = function()
    lvim.builtin.treesitter.playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    }
  end,
}
-- }}}

-- nvim-treesitter-textobjects {{{

---@return nil
local setup_nvim_treesitter_objects = function()
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-select
  lvim.builtin.treesitter.textobjects['select'] = {
    enable = true,
    lookahead = true,
    keymaps = {
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    },
  }

  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#textobjects-lsp-interop
  lvim.builtin.treesitter.textobjects['lsp_interop'] = {
    enable = true,
    border = 'rounded',
    peek_definition_code = {
      -- ["<leader>lF"] = "@function.outer",
      -- ['<leader>lC'] = '@class.outer',
    },
  }

  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-swap
  -- DO NOT which-key this, it will cause gg to lock up neovim
  lvim.builtin.treesitter.textobjects['swap'] = {
    enable = true,
    swap_next = { ['g>'] = '@parameter.inner' },
    swap_previous = { ['g<'] = '@parameter.inner' },
  }

  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#text-objects-move
  lvim.builtin.treesitter.textobjects['move'] = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      [']m'] = '@function.outer',
      [']c'] = '@class.outer',
      -- [']i'] = '@interface.outer', -- WIP
    },
    goto_next_end = {
      [']['] = '@function.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
      ['[c'] = '@class.outer',
    },
    goto_previous_end = {
      ['[]'] = '@function.outer',
    },
  }
end

local configure_nvim_treesitter_textobjects = function()
  if not is_installed('which-key') then return end

  require 'which-key'.register({
    [']'] = 'Next Method',
    ['['] = 'End of Next Method',
    ['c'] = 'Next Class',
    i = 'Next Interface',
  }, { prefix = ']' })

  require 'which-key'.register({
    ['['] = 'Previous Method',
    [']'] = 'End of Previous Method',
    ['c'] = 'Previous Class',
  }, { prefix = '[' })

  -- hmm, this is not as useful as it looks. It doesn't peek any surrounding
  -- definition well... it just lets you peek the parent class definition
  -- from a function definition.
  -- require 'which-key'.register({
  --   l = {
  --     ['C'] = 'Peek Class Definition',
  --     -- ['F'] = 'Peek Function Definition',
  --   }
  -- }, { prefix = '<Leader>' })
end

plugins.nvim_treesitter_textobjects = {
  'nvim-treesitter/nvim-treesitter-textobjects',
  -- event = 'BufRead',
  ft = {
    'javascript',
    'javascriptreact',
    'lua',
    'php',
    'python',
    'ruby',
    'typescript',
    'typescriptreact',
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'folke/which-key.nvim',
  },
  init = setup_nvim_treesitter_objects,
  config = configure_nvim_treesitter_textobjects,
}
-- }}}

-- nvim-ts-autotag {{{
plugins.nvim_ts_autotag = {
  'windwp/nvim-ts-autotag',
  ft = {
    'html',
    'javascript',
    'javascriptreact',
    'php.html',
    'typescript',
    'typescriptreact',
    'xml',
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  init = function() lvim.builtin.treesitter.autotag.enable = true end,
}
-- }}}

-- nvim-ufo {{{
plugins.nvim_ufo = {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
    'folke/which-key.nvim',
  },
  lazy = true, -- this is loaded in some ftplugins after lsp setup
  config = function()
    vim.o.foldcolumn = '1' -- make folds visible left of the sign column. Very cool ui feature!
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require 'which-key'.register({
      R = { require 'ufo'.openAllFolds, 'Open All Folds' },
      M = { require 'ufo'.closeAllFolds, 'Close All Folds' },
      -- r = { require 'ufo'.openFoldsExceptKinds, 'Open Folds Except Kinds' },
      -- m = { require 'ufo'.closeFoldsWith, 'Close Folds With' },
    }, { prefix = 'z' })

    vim.keymap.set('n', 'K', function()
      local winid = require 'ufo'.peekFoldedLinesUnderCursor()
      if not winid then vim.lsp.buf.hover() end
    end)

  end,
  -- opts = {
  --   provider_selector = function(_, _, _)
  --     return { 'treesitter', 'indent' }
  --   end,
  -- }
}
-- }}}

-- nvim-various-textobjs {{{
plugins.nvim_various_textobjs = {
  'chrisgrieser/nvim-various-textobjs',
  -- event = 'BufRead',
  -- config = function()
  --   require 'various-textobjs'.setup {
  --     useDefaultKeymaps = true,
  --   }
  -- end,
}
-- }}}

-- nvim-yati {{{
plugins.nvim_yati = {
  'yioneko/nvim-yati',
  version = '*',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  init = function()
    lvim.builtin.treesitter.yati = { enable = true }
    lvim.builtin.treesitter.indent.enable = false
  end
}
-- }}}

-- org-bullets.nvim {{{
local configure_org_bullets = function()
  require 'org-bullets'.setup {}
  require 'org-bullets'.__init() -- init on first entering markdown file

  -- setup autocmd for future entering of markdown files
  vim.api.nvim_create_augroup('markdown_org_bullets', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    group = 'markdown_org_bullets',
    callback = function()
      local is_org_bullets_installed, org_bullets = pcall(require, 'org-bullets')
      if not is_org_bullets_installed then return end
      org_bullets.__init()
    end
  })
end

plugins.org_bullets = {
  'akinsho/org-bullets.nvim',
  commit = '8dc2e25088ffa10029157c9aaede7d79f3fc75b1',
  ft = 'markdown',
  config = configure_org_bullets,
}
-- }}}

-- persistent-breakpoints {{{
plugins.persistent_breakpoints = {
  'Weissle/persistent-breakpoints.nvim',
  -- ft = {
  --   'php',
  --   'javascript',
  --   'ruby',
  --   'python',
  -- },
  dependencies = { 'mfussenegger/nvim-dap' },
  init = function()
    lvim.builtin.which_key.mappings['d']['t'] = {
      function() require 'persistent-breakpoints.api'.toggle_breakpoint() end,
      'Toggle Breakpoint',
    }
    lvim.builtin.which_key.mappings['d']['X'] = {
      function() require 'persistent-breakpoints.api'.clear_all_breakpoints() end,
      'Clear All Breakpoints',
    }
    lvim.builtin.which_key.mappings['d']['e'] = {
      function() require 'persistent-breakpoints.api'.set_conditional_breakpoint() end,
      'Expression Breakpoint',
    }
  end,
  opts = { load_breakpoints_event = { 'BufReadPost' } },
}
-- }}}

-- phpactor_nvim {{{
local configure_phpactor_nvim = function()
  local php_bin_path = vim.env.HOME .. '/.asdf/installs/php/8.2.12/bin'
  require 'phpactor'.setup {
    lspconfig = { enabled = false },
    install = {
      bin = mason_path .. '/bin/phpactor',
      path = mason_path .. '/packages/phpactor',
      php_bin = php_bin_path .. '/php',
      composer_bin = php_bin_path .. '/composer',
    }
  }
  if not is_installed('which-key') then return end

  require 'which-key'.register({
    r = {
      name = 'Refactor',
      r = { '<Cmd>PhpActor context_menu<CR>', 'PHP Menu' },
      c = { '<Cmd>PhpActor copy_class<CR>', 'PHP Copy Class' },
      m = { '<Cmd>PhpActor move_class<CR>', 'PHP Move Class' },
      -- x = { '<Cmd>PhpActor extract_expression<CR>', 'PHP Extract Expression' }, -- not implemented
      -- C = { '<Cmd>PhpActor extract_constant<CR>', 'PHP Extract Constant' }, -- not implemented
      i = { '<Cmd>PhpActor class_inflect<CR>', 'PHP Inflect Class' },
      I = { '<Cmd>PhpActor import_missing_classes<CR>', 'PHP Import Missing' },
      p = { '<Cmd>PhpActor transform<CR>', 'PHP Add Missing Properties' },

      -- class options:
      --
      -- goto_definition
      -- hover
      -- copy
      -- generate_accessor (doesn't work... something about nullable)
      -- import_missing_classes
      -- find_references
      -- transform_file
      -- replace_references
      -- generate_mutator (doesn't work... something about nullable)
      -- override_method (useful! filter through parent methods to copy empty signature to)
      -- inflect
      -- goto_implementation
      -- class_new
      -- move
      -- import
      -- navigate
    }
  }, { prefix = '<Leader>' })

  require 'which-key'.register({
    r = {
      name = 'Refactor PHP',
      -- e = { ":'<,'>PhpActor extract_method<CR>", 'PHP Extract Method' }, -- overlap with refactoring.nvim, not implemented
      -- x = { ":'<,'>PhpActor extract_expression<CR>", 'PHP Extract Expression' }, -- not implemented
      m = { ":'<,'>PhpActor context_menu<CR>", 'PHP Menu' },
    }
  }, { prefix = '<Leader>', mode = 'v' })

  require 'which-key'.register({ v = { '<Cmd>PhpActor change_visibility<CR>', 'PHP Cycle Visibility' } }, { prefix = ']' })
end

plugins.phpactor_nvim = {
  -- 'gbprod/phpactor.nvim',
  'mikedfunk/phpactor.nvim', branch = 'mikedfunk-patch-1', -- fix bug - see https://github.com/gbprod/phpactor.nvim/pull/23
  ft = 'php',
  dependencies = {
    'folke/which-key.nvim',
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
  },
  config = configure_phpactor_nvim,
  build = function() require 'phpactor.handler.update' () end,
}
-- }}}

-- range-highlight.nvim {{{
plugins.range_highlight_nvim = {
  'winston0410/range-highlight.nvim',
  event = 'CmdlineEnter',
  dependencies = 'winston0410/cmd-parser.nvim',
}
-- }}}

-- refactoring.nvim {{{

plugins.refactoring_nvim = {
  'ThePrimeagen/refactoring.nvim',
  ft = {
    'golang',
    'java',
    'javascript',
    'javascriptreact',
    'lua',
    'php',
    'python',
    'typescript',
    'typescriptreact',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'folke/which-key.nvim',
    'jose-elias-alvarez/null-ls.nvim',
  },
  init = function()
    lvim.builtin.which_key.vmappings['r'] = {
      name = 'Refactor',
      v = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable', silent = true },
      V = { "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' }, -- doesn't work in php
      e = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", 'Extract Function', silent = true },
      f = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", 'Extract Function to File', silent = true },
      t = { "<Esc><Cmd>lua require 'telescope'.extensions.refactoring.refactors()<CR>", 'Show Refactors' },
    }

    lvim.builtin.which_key.mappings['r'] = {
      name = 'Refactor',
      b = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Block')<CR>", 'Extract Block', silent = true },
      f = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", 'Extract Block to File', silent = true },
    }
  end,
}
-- }}}

-- splitjoin.vim {{{

plugins.splitjoin_vim = {
  'AndrewRadev/splitjoin.vim',
  ft = {
    'bash',
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'lua',
    'php',
    'python',
    'ruby',
    'sh',
    'typescript',
    'typescriptreact',
    'zsh',
  },
  branch = 'main',
  dependencies = 'folke/which-key.nvim',
  init = function()
    vim.g['splitjoin_php_method_chain_full'] = 1
    vim.g['splitjoin_quiet'] = 1
    vim.g['splitjoin_trailing_comma'] = require 'saatchiart.plugin_configs'.should_enable_trailing_commas() and 1 or 0
  end,
  config = function()
    if is_installed('which-key') then
      require 'which-key'.register({
        J = { name = 'Join' },
        S = { name = 'Split' },
      }, { prefix = 'g' })
    end
  end,
}
-- }}}

-- statuscol.nvim {{{
plugins.statuscol_nvim = {
  'luukvbaal/statuscol.nvim',
  config = function()
    require 'statuscol'.setup {
      -- relculright = true,
      -- segments = {
      --   { text = { require 'statuscol.builtin'.foldfunc }, click = "v:lua.ScFa" },
      --   {
      --     sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
      --     click = "v:lua.ScSa"
      --   },
      --   { text = { require 'statuscol.builtin'.lnumfunc }, click = "v:lua.ScLa", },
      --   {
      --     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true },
      --     click = "v:lua.ScSa"
      --   },
      -- }
    }
  end
}
-- }}}

-- surround-ui.nvim {{{
plugins.surround_ui_nvim = {
  'roobert/surround-ui.nvim',
  dependencies = {
    'kylechui/nvim-surround',
    'folke/which-key.nvim',
  },
  opts = {
    root_key = 'U'
  }
}
-- }}}

-- symbols-outline.nvim {{{

---@param _ table
---@param bufnr integer
---@return nil
plugins.symbols_outline_on_attach = function(_, bufnr)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<Cmd>SymbolsOutline<CR>', { noremap = true })
  if is_installed('which-key') then
    require 'which-key'.register({
      l = {
        o = { '<Cmd>SymbolsOutline<CR>', 'Symbols Outline', buffer = bufnr }
      }
    }, { prefix = '<Leader>' })
  end
end

plugins.symbols_outline_nvim = {
  'simrat39/symbols-outline.nvim',
  event = 'BufRead',
  dependencies = 'folke/which-key.nvim',
  init = function()
    local heading_options = {
      filetype = 'Outline',
      highlight = 'PanelHeading',
      padding = 1,
      text = 'Symbols'
    }
    if vim.tbl_contains(lvim.builtin.bufferline.options.offsets, heading_options) then return end
    table.insert(lvim.builtin.bufferline.options.offsets, heading_options)

    vim.cmd 'hi link FocusedSymbol TermCursor'
  end,
  opts = {
    width = 35,
    border = 'rounded',
    winblend = vim.o.winblend,
    relative_width = false,
    auto_close = true,
    -- highlight_hovered_item = false,
    -- auto_preview = true,
    autofold_depth = 2,
    auto_unfold_hover = false,
    show_symbol_details = true,
    -- possible values https://github.com/simrat39/symbols-outline.nvim/blob/master/lua/symbols-outline/symbols.lua
    -- symbol_blacklist = {
    --   -- works best for object-oriented code
    --   'Field',
    --   'Function',
    --   'Key',
    --   'Variable',
    -- },
    symbols = {
      Array = { icon = lvim.icons.kind.Array },
      Boolean = { icon = lvim.icons.kind.Boolean },
      Class = { icon = lvim.icons.kind.Class },
      Component = { icon = lvim.icons.kind.Function },
      Constant = { icon = lvim.icons.kind.Constant },
      Constructor = { icon = lvim.icons.kind.Constructor },
      Enum = { icon = lvim.icons.kind.Enum },
      EnumMember = { icon = lvim.icons.kind.EnumMember },
      Event = { icon = lvim.icons.kind.Event },
      Field = { icon = lvim.icons.kind.Field },
      File = { icon = lvim.icons.kind.File },
      Fragment = { icon = lvim.icons.kind.Constant },
      Function = { icon = lvim.icons.kind.Function },
      Interface = { icon = lvim.icons.kind.Interface },
      Key = { icon = lvim.icons.kind.Key },
      Method = { icon = lvim.icons.kind.Method },
      Module = { icon = lvim.icons.kind.Module },
      Namespace = { icon = lvim.icons.kind.Namespace },
      Null = { icon = lvim.icons.kind.Null },
      Number = { icon = lvim.icons.kind.Number },
      Object = { icon = lvim.icons.kind.Object },
      Operator = { icon = lvim.icons.kind.Operator },
      Package = { icon = lvim.icons.kind.Package },
      Property = { icon = lvim.icons.kind.Property },
      String = { icon = lvim.icons.kind.String },
      Struct = { icon = lvim.icons.kind.Struct },
      TypeParameter = { icon = lvim.icons.kind.TypeParameter },
      Variable = { icon = lvim.icons.kind.Variable },
    },
  },
}
-- }}}

-- tabout.nvim {{{
plugins.tabout_nvim = {
  'abecodes/tabout.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp',
  },
  event = 'InsertEnter',
  opts = {},
}
-- }}}

-- telescope-dap.nvim {{{
plugins.telescope_dap_nvim = {
  'nvim-telescope/telescope-dap.nvim',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-telescope/telescope.nvim',
  },
  init = function()
    lvim.builtin.which_key.mappings.d = lvim.builtin.which_key.mappings.d or {}
    lvim.builtin.which_key.mappings.d.l = { function() require 'telescope'.extensions.dap.list_breakpoints {} end, 'List Breakpoints' }
    lvim.builtin.which_key.mappings.d.v = { function() require 'telescope'.extensions.dap.variables {} end, 'Variables' }
    lvim.builtin.which_key.mappings.d.v = { function() require 'telescope'.extensions.dap.frames {} end, 'Call Stack' }
  end,
  config = function() require 'telescope'.load_extension 'dap' end,
}
-- }}}

-- telescope-import.nvim {{{
plugins.telescope_import_nvim = {
  'piersolenski/telescope-import.nvim',
  ft = { 'typescript', 'typescriptreact', 'javascript', 'react' },
  dependencies = 'nvim-telescope/telescope.nvim',
  config = function ()
    require 'telescope'.load_extension('import')
  end,
}
-- }}}

-- telescope-lazy.nvim {{{
plugins.telescope_lazy_nvim = {
  'tsakirist/telescope-lazy.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  init = function()
    lvim.builtin.which_key.mappings.p = lvim.builtin.which_key.mappings.p or {}
    lvim.builtin.which_key.mappings.p.f = { function() vim.cmd('Telescope lazy') end, 'Find' }
  end,
  config = function() require 'telescope'.load_extension 'lazy' end,
}
-- }}}

-- telescope-undo.nvim {{{
plugins.telescope_undo_nvim = {
  'debugloop/telescope-undo.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  keys = {
    { '<Leader>u', '<Cmd>Telescope undo<CR>', desc = 'Telescope Undo' },
  },
  init = function()
    lvim.builtin.telescope.extensions.undo = {
      mappings = {
        i = {
          ["<cr>"] = require("telescope-undo.actions").restore,
        },
      },
    }
  end,
  config = function()
    require 'telescope'.load_extension 'undo'
  end,
}
-- }}}

-- text-case.nvim {{{
plugins.text_case_nvim = {
  'johmsalas/text-case.nvim',
  event = 'BufRead',
  dependencies = {
    -- 'folke/which-key.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
  },
  init = function()
    lvim.builtin.which_key.mappings['C'] = {
      name = 'Coerce',
      c = { function() require 'textcase'.current_word('to_camel_case') end, 'camelCase' },
      S = { function() require 'textcase'.current_word('to_pascal_case') end, 'StudlyCase' },
      s = { function() require 'textcase'.current_word('to_snake_case') end, 'snake_case' },
      k = { function() require 'textcase'.current_word('to_dash_case') end, 'kebab-case' },
      ['.'] = { '<Cmd>TextCaseOpenTelescope<CR>', 'Telescope' },
    }

    lvim.builtin.which_key.vmappings['C'] = {
      name = 'Coerce',
      ['.'] = { '<Cmd>TextCaseOpenTelescope<CR>', 'Telescope' },
    }
  end,
  config = function()
    require 'textcase'.setup {}
    require 'telescope'.load_extension 'textcase'
  end,
}
-- }}}

-- todo-comments.nvim {{{

plugins.todo_comments_nvim = {
  'folke/todo-comments.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  event = 'BufRead',
  opts = {
    -- highlight = {
    --   after = '',
    --   pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlightng (vim regex) https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
    -- },
    -- search = {
    --   pattern = [[\b(KEYWORDS)]], -- ripgrep regex
    -- }
  },
  init = function()
    if not is_installed('which-key') then return end
    require 'which-key'.register({ s = { T = { '<Cmd>TodoTelescope<CR>', 'Todos' } } }, { prefix = '<leader>' })
  end
}
-- }}}

-- tmuxline.vim {{{

-- dark
vim.g['tmuxline_theme'] = {
  a = { '16', '254', 'bold' },
  b = { '247', '236'},
  c = { '250', '233' },
  x = { '250', '233' },
  y = { '247', '236'},
  z = { '235', '252' },
  bg = { '247', '234'},
  win = { '250', '234' },
  ['win.dim'] = { '244', '234' },
  cwin = { '231', '31', 'bold' },
  ['cwin.dim'] = { '117', '31' },
}

-- light
-- vim.g['tmuxline_theme'] = {
--   a = { '238', '253', 'bold' },
--   b = { '255', '238' },
--   c = { '255', '236'},
--   x = { '255', '236' },
--   y = { '255', '238'},
--   z = { '238', '253' },
--   bg = { '16', '254'},
--   win = { '16', '254' },
--   cwin = { '231', '31', 'bold' },
-- }

plugins.tmuxline_vim = {
  'edkolev/tmuxline.vim',
  cmd = { 'Tmuxline', 'TmuxlineSnapshot' },
  init = function()
    vim.g['tmuxline_preset'] = {
      a = { '#S' }, -- session name |
      b = {
        table.concat({
          '#{cpu_fg_color}#{cpu_icon}#[fg=default]',
          '#{ram_fg_color}#{ram_icon}#[fg=default]',
          '#{battery_color_charge_fg}#[bg=colour' .. vim.g.tmuxline_theme.b[2] .. ']#{battery_icon_charge}#{battery_color_status_fg}#[bg=colour'  .. vim.g.tmuxline_theme.b[2] .. ']#{battery_icon_status}#[fg=default]#{wifi_icon}',
        }, ' '),
      },
      c = { '#(~/.support/tmux-docker-status.sh)' },
      win = { '#I', '#W#{?window_bell_flag, ,}#{?window_zoomed_flag, ,}' }, -- unselected tab
      cwin = { '#I', '#W#{?window_zoomed_flag, ,}' }, -- current tab
      x = { "#(TZ=Etc/UTC date '+%%R UTC')" }, -- UTC time
      y = { '%l:%M %p' }, -- local time
      z = { '%a', '%b %d' }, -- local date
    }

    vim.cmd 'command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.config/tmux/tmuxline-dark.conf' -- apply tmuxline settings and snapshot to file
  end,
}
-- }}}

-- treesitter-indent-object.nvim {{{
plugins.treesitter_indent_object_nvim = {
  "kiyoon/treesitter-indent-object.nvim",
  keys = {
    -- {
    --   "ai",
    --   function() require'treesitter_indent_object.textobj'.select_indent_outer() end,
    --   mode = {"x", "o"},
    --   desc = "Select context-aware indent (outer)",
    -- },
    {
      "ai",
      function() require'treesitter_indent_object.textobj'.select_indent_outer(true) end,
      mode = {"x", "o"},
      desc = "Select context-aware indent (outer, line-wise)",
    },
    -- {
    --   "ii",
    --   function() require'treesitter_indent_object.textobj'.select_indent_inner() end,
    --   mode = {"x", "o"},
    --   desc = "Select context-aware indent (inner, partial range)",
    -- },
    {
      "ii",
      function() require'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end,
      mode = {"x", "o"},
      desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
    },
  },
}
-- }}}

-- ts-node-action {{{
plugins.ts_node_action = {
  'CKolkey/ts-node-action',
  event = 'BufRead',
  -- ft = {
  --   'php',
  --   'lua',
  --   'javascript',
  --   'typescript',
  --   'javascriptreact',
  --   'typescriptreact',
  --   'python',
  --   'ruby',
  -- },
  dependencies = 'folke/which-key.nvim',
  config = function()
    -- local padding = {
    --   [','] = '%s ',
    --   ['=>'] = ' %s ',
    --   ['='] = '%s',
    --   ['['] = '%s',
    --   [']'] = '%s',
    --   ['}'] = '%s',
    --   ['{'] = '%s',
    --   ['||'] = ' %s ',
    --   ['&&'] = ' %s ',
    --   ['.'] = ' %s ',
    --   ['+'] = ' %s ',
    --   ['*'] = ' %s ',
    --   ['-'] = ' %s ',
    --   ['/'] = ' %s ',
    -- }
    -- local toggle_multiline = require('ts-node-action.actions.toggle_multiline')(padding)
    require 'ts-node-action'.setup {
      -- php = {
      --   array_creation_expression = toggle_multiline,
      --   formal_parameters = toggle_multiline,
      --   arguments = toggle_multiline,
      --   subscript_expression = toggle_multiline,
      -- }
    }

    require 'lvim.lsp.null-ls.code_actions'.setup {
      { name = 'ts_node_action' },
    }

    -- if not is_installed('which-key') then return end
    -- require 'which-key'.register({
    --   J = {
    --     function() require 'ts-node-action'.node_action() end,
    --     'Split/Join'
    --   },
    -- }, { prefix = 'g' })
  end,
}
-- }}}

-- typescript.nvim (TODO: replace, being archived) {{{
plugins.typescript_nvim = {
  'jose-elias-alvarez/typescript.nvim',
  dependencies = { 'jose-elias-alvarez/null-ls.nvim' },
  -- dependencies = { 'jose-elias-alvarez/null-ls.nvim', 'kevinhwang91/nvim-ufo' },
  ft = {
    -- 'javascript',
    'typescript',
    'typescriptreact',
  },
  config = function()
    local capabilities = require 'lvim.lsp'.common_capabilities()

    if is_installed('ufo') then
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    end

    require 'typescript'.setup {
      server = {
        on_attach = require 'lvim.lsp'.common_on_attach,
        on_init = require 'lvim.lsp'.common_on_init,
        on_exit = require 'lvim.lsp'.common_on_exit,
        capabilities = capabilities,
      }
    }

    require 'null-ls'.register { sources = { require 'typescript.extensions.null-ls.code-actions' } }
  end
}
-- }}}

-- undotree {{{

---@return nil
local setup_undotree = function()
  lvim.builtin.which_key.mappings['u'] = { '<Cmd>UndotreeToggle<CR>', 'Undo History' }
end
-- undotree lazy loads on this command, so we define the keymap before the plugin is loaded

plugins.undotree = {
  'mbbill/undotree',
  cmd = { 'UndotreeToggle', 'UndotreeShow' },
  init = setup_undotree,
}
-- }}}

-- vim-abolish {{{
plugins.vim_abolish = {
  'tpope/vim-abolish',
  init = function()
    vim.g.abolish_no_mappings = 1
    vim.g.abolish_save_file = vim.env.LUNARVIM_RUNTIME_DIR .. '/after/plugin/abolish.vim'
  end,
  config = function()
    vim.cmd('Abolish colleciton ollection')
    vim.cmd('Abolish connecitno connection')
    vim.cmd('Abolish conneciton connection')
    vim.cmd('Abolish deafult default')
    vim.cmd('Abolish leagcy legacy')
    vim.cmd('Abolish sectino section')
    vim.cmd('Abolish seleciton selection')
    vim.cmd('Abolish striketrough strikethrough')
    vim.cmd('iabbrev shouldREturn shouldReturn')
    vim.cmd('iabbrev willREturn willReturn')
    vim.cmd('iabbrev willTHrow willThrow')
  end
}
-- }}}

-- vim-fugitive {{{
-- vim.cmd('command! -nargs=1 Browse !open <args>') -- allow GBrowse to work without netrw installed. It's not perfect.

---@return nil
local configure_fugitive = function()
  vim.cmd('command! -nargs=1 Browse OpenBrowser <args>') -- allow GBrowse to work with open-browser.nvim instead of netrw
  -- vim.api.nvim_set_keymap('n', 'y<c-g>', ':<C-U>call setreg(v:register, fugitive#Object(@%))<CR>', { noremap = true, silent = true }) -- work around an issue preventing lazy loading with y<c-g> from working

  if not is_installed('which-key') then return end

  require 'which-key'.register({ g = { G = { '<Cmd>Git<CR>', 'Fugitive' } } }, { prefix = '<Leader>' })

  require 'which-key'.register({
    o = { name = 'Toggle...' },
    ['<c-g>'] = { name = 'Copy path' },
  }, { prefix = 'y' })
end

-- local fugitive_commands = {
--   'G',
--   'GBrowse',
--   'GDelete',
--   'GMove',
--   'GRemove',
--   'GRename',
--   'Gdiffsplit',
--   'Gedit',
--   'Ggrep',
--   'Git',
--   'Glgrep',
--   'Gread',
--   'Gvdiffsplit',
--   'Gwrite',
-- }

plugins.vim_fugitive = {
  'tpope/vim-fugitive',
  -- ft = { 'fugitive' },
  -- cmd = fugitive_commands,
  -- keys = 'y<c-g>',
  dependencies = {
    'tpope/vim-rhubarb',
    'tyru/open-browser.vim',
    'folke/which-key.nvim',
  },
  config = configure_fugitive,
}
-- }}}

-- vim-git {{{

---@return nil
local configure_vim_git = function()
  local current_buf = vim.api.nvim_get_current_buf()
  vim.keymap.set('n', 'I', '<Cmd>Pick<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'R', '<Cmd>Reword<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'E', '<Cmd>Edit<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'S', '<Cmd>Squash<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'F', '<Cmd>Fixup<cr>', { buffer = current_buf, noremap = true })
  vim.keymap.set('n', 'D', '<Cmd>Drop<cr>', { buffer = current_buf, noremap = true })

  -- need to test these (visual mode)
  vim.keymap.set('v', 'I', ":'<,'>Pick<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'R', ":'<,'>Reword<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'E', ":'<,'>Edit<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'S', ":'<,'>Squash<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'F', ":'<,'>Fixup<cr>", { buffer = current_buf, noremap = true })
  vim.keymap.set('v', 'D', ":'<,'>Drop<cr>", { buffer = current_buf, noremap = true })
end

plugins.vim_git = { 'tpope/vim-git', ft = 'gitrebase', config = configure_vim_git }
-- }}}

-- vim-jdaddy {{{
plugins.vim_jdaddy = {
  'tpope/vim-jdaddy',
  event = 'BufRead',
  config = function()
    if not is_installed('which-key') then return end
    require 'which-key'.register({
      q = { name = 'Format JSON', a = { name = 'Format JSON', j = { name = 'Format JSON' } } },
      w = { name = 'Format JSON', a = { name = 'Format JSON', j = { name = 'Format JSON outer' } } },
    }, { prefix = 'g' })
  end,
}
-- }}}

-- vim-lion {{{

plugins.vim_lion = {
  'tommcdo/vim-lion',
  event = 'BufRead',
  dependencies = 'folke/which-key.nvim',
  init = function()
    vim.g['lion_map_right'] = 'ga'
    vim.g['lion_squeeze_spaces'] = true
  end,
  config = function()
    require 'which-key'.register({
      a = 'Align operator right',
      L = 'Align operator left',
    }, { prefix = 'g' })
  end,
}
-- }}}

-- vim-matchup {{{

plugins.vim_matchup = {
  'andymass/vim-matchup',
  event = 'CursorMoved',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  init = function()
    lvim.builtin.treesitter.matchup.enable = true
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    -- vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
    vim.g.matchup_surround_enabled = 1
  end,
}
-- }}}

-- vim-projectionist {{{
plugins.vim_projectionist = {
  'tpope/vim-projectionist',
  event = 'BufRead',
  init = function()
    lvim.builtin.which_key.mappings.A = {
      name = 'Alternate',
      a = { '<Cmd>A<CR>', 'Alternate file' },
      v = { '<Cmd>AV<CR>', 'Alternate vsplit' },
      s = { '<Cmd>AS<CR>', 'Alternate split' },
      t = { '<Cmd>AT<CR>', 'Alternate tab' },
    }
  end
}
-- }}}

-- vim-startify {{{

---@return nil
local setup_startify = function()
  -- doesn't work since it's full screen
  -- table.insert(lvim.builtin.bufferline.options.offsets, {
  --   filetype = 'startify',
  --   highlight = 'PanelHeading',
  --   padding = 1,
  --   text = 'Startify'
  -- })

  vim.g['ascii'] = {}
  vim.g['startify_custom_header'] = 'map(g:ascii + startify#fortune#boxed(), "\\"   \\".v:val")'
  local are_my_startify_quotes_found, my_startify_quotes = pcall(require, 'mikedfunk.startify_quotes')
  if are_my_startify_quotes_found then vim.g['startify_custom_header_quotes'] = my_startify_quotes end
  vim.g['startify_fortune_use_unicode'] = 1
  vim.g['startify_relative_path'] = 1
  vim.g['startify_use_env'] = 1 -- use $HOME instead of full path for instance

  vim.g['startify_enable_special'] = 0 -- show empty buffer and quit
  vim.g['startify_enable_unsafe'] = 1 -- speeds up startify but sacrifices some accuracy
  vim.g['startify_session_sort'] = 1 -- sort descending by last used
  vim.cmd [[let g:startify_custom_indices = map(range(1,100), 'string(v:val)')]] -- start at 1
  vim.g['startify_skiplist'] = { 'COMMIT_EDITMSG', '.DS_Store' } -- disable common but unimportant files
  vim.g['startify_files_number'] = 9 -- recently used
  vim.g['startify_session_persistence'] = 1 -- auto save session on exit like obsession
  -- vim.g['startify_session_dir'] = vim.env.HOME .. '/.local/share/lunarvim/session' .. vim.fn.getcwd() -- session dir for each repo
  vim.g['startify_session_dir'] = vim.fn.stdpath('data') .. '/session/' .. vim.fn.getcwd() -- session dir for each repo
  vim.g['startify_change_to_dir'] = 0 -- this feature should not even exist. It is stupid.

  -- reorder and whitelist certain groups
  vim.g['startify_lists'] = {
    { type = 'sessions',  header = { '   Sessions' } },
    { type = 'dir',       header = { '   Recent in ' .. vim.fn.getcwd() } },
    { type = 'bookmarks', header = { '   Bookmarks' } },
  }

  require 'saatchiart.plugin_configs'.configure_startify_bookmarks()

  lvim.builtin.which_key.mappings.S = {
    name = 'Session',
    h = { '<Cmd>Startify<CR>', 'Home' },
    s = { '<Cmd>SSave<CR>', 'Save' },
    l = { '<Cmd>SLoad<CR>', 'Load' },
    d = { '<Cmd>SDelete!<CR>', 'Delete' },
    c = { '<Cmd>SClose<CR>', 'Close' },
  }
  lvim.builtin.which_key.mappings.H = { '<Cmd>Startify<CR>', 'Home' }
end

plugins.vim_startify = {
  'mhinz/vim-startify',
  -- event = 'VimEnter',
  init = setup_startify,
}

-- }}}

-- vim-unimpaired {{{

---@return nil
local configure_vim_unimpaired = function()
  if not is_installed('which-key') then return end
  require 'which-key'.register({
    ['<space>'] = 'Add line below',
    a = 'Next file',
    A = 'Last file',
    -- b = 'Next buffer',
    B = 'Last buffer',
    C = 'String decode',
    e = 'Move line down',
    f = 'Next file in dir',
    l = 'Next in loclist',
    ['<c-l>'] = 'Next in loclist',
    L = 'Last in loclist',
    m = 'Next method start',
    M = 'Next method end',
    -- n = 'Next diff',
    o = 'Disable...',
    p = 'Paste below',
    P = 'Paste below',
    q = 'Next in quickfix',
    ['<c-q>'] = 'Next in quickfix',
    Q = 'Last in quickfix',
    -- t = 'Next tag',
    -- T = 'Last tag',
    u = { name = 'URL decode', u = { name = 'URL decode' } },
    x = { name = 'XML decode', x = { name = 'XML decode' } },
    y = { name = 'String decode', y = { name = 'String decode' } },
    ['<c-t>'] = 'Next preview',
  }, { prefix = ']' })

  require 'which-key'.register({
    ['<space>'] = 'Add line above',
    a = 'Previous file',
    A = 'First file',
    -- b = 'Previous buffer',
    B = 'First buffer',
    C = 'String encode',
    e = 'Move line up',
    f = 'Previous file in dir',
    l = 'Previous in loclist',
    ['<c-l>'] = 'Previous in loclist',
    L = 'First in loclist',
    m = 'Previous method start',
    M = 'Previous method end',
    -- n = 'Previous diff',
    o = 'Enable...',
    p = 'Paste above',
    P = 'Paste above',
    q = 'Previous in quickfix',
    Q = 'First in quickfix',
    ['<c-q>'] = 'Previous in quickfix',
    t = 'Previous tag',
    ['<c-t>'] = 'Previous tag',
    T = 'First tag',
    u = { name = 'URL encode', u = { name = 'URL encode' } },
    x = { name = 'XML encode', x = { name = 'XML encode' } },
    y = { name = 'String encode', y = { name = 'String encode' } },
  }, { prefix = '[' })

  require 'which-key'.register({
    o = { name = 'Toggle...' },
    -- ['<c-g>'] = { name = 'Copy path' },
  }, { prefix = 'y' })
end

plugins.vim_unimpaired = {
  'tpope/vim-unimpaired',
  event = 'BufRead',
  dependencies = 'folke/which-key.nvim',
  config = configure_vim_unimpaired,
}
-- }}}

-- zk.nvim {{{
-- local setup_zk_conceal = function()
--   vim.cmd [[
--   " markdownWikiLink is a new region
--   syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends
--   " markdownLinkText is copied from runtime files with 'concealends' appended
--   syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends
--   " markdownLink is copied from runtime files with 'conceal' appended
--   syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal
--   ]]

--   vim.wo.conceallevel = 2
-- end

plugins.zk_nvim = {
  'mickael-menu/zk-nvim',
  ft = 'markdown',
  branch = 'main',
  init = function()
    -- lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { 'markdown' }

    lvim.builtin.which_key.mappings['z'] = {
      name = 'Zettelkasten',
      n = { '<Cmd>ZkNew { title = vim.fn.input("Title: ") }<CR>', 'New' },
      o = { '<Cmd>ZkNotes { sort = { "modified" } }<CR>', 'Open' },
      t = { '<Cmd>ZkTags<CR>', 'Tags' },
      s = { '<Cmd>ZkNotes { sort = { "modified" }, match = vim.fn.input("Search: ") }<CR>', 'Search' },
    }

    lvim.builtin.which_key.vmappings['z'] = {
      name = 'Zettelkasten',
      s = { ":'<,'>ZkMatch<CR>", 'Search' },
      t = { ":'<,'>ZkNewFromTitleSelection { dir = 'general' }<CR>", 'New from Title' },
      c = { ":'<,'>ZkNewFromContentSelection { dir = 'general' }<CR>", 'New from Content' },
    }

    -- vim.api.nvim_create_augroup('zk_conceal', { clear = true })
    -- vim.api.nvim_create_autocmd('FileType', { pattern = 'markdown', group = 'zk_conceal', callback = setup_zk_conceal })
  end,
  -- config = function()
  --   require 'zk'.setup()
  -- end
}
-- }}}

-- }}}

-- mappings (including whichkey) and commands {{{
-- lvim.keys.normal_mode['<C-s>'] = ':nohlsearch<cr>'
lvim.keys.normal_mode['<C-w>t'] = 'mz:tabe %<cr>`z'
lvim.keys.normal_mode['<c-l>'] = ':silent! call LocListToggle()<CR>'

lvim.builtin.which_key.mappings['e'] = { '<Cmd>NvimTreeFindFileToggle<CR>', 'Explore File' }
lvim.builtin.which_key.mappings['m'] = { '<Cmd>silent make<CR>', 'Make' }
lvim.builtin.which_key.mappings['E'] = { '<Cmd>NvimTreeToggle<CR>', 'Explore' }

lvim.builtin.which_key.mappings['l']['c'] = { '<Cmd>LspSettings buffer<CR>', 'Configure LSP' }
lvim.builtin.which_key.mappings['l']['R'] = { '<Cmd>LspRestart<CR>', 'Restart LSP' }

lvim.builtin.which_key.mappings['b']['d'] = { '<Cmd>bd<CR>', 'Delete' }
lvim.builtin.which_key.mappings['b']['f'] = { '<Cmd>Telescope buffers initial_mode=insert sort_mru=true<CR>', 'Find' }
lvim.builtin.which_key.mappings['b']['p'] = { '<Cmd>BufferLineTogglePin<CR>', 'Pin/Unpin' }
lvim.builtin.which_key.mappings['b']['o'] = { '<Cmd>BufferLineGroupClose ungrouped<CR>', 'Delete All but Pinned' }

-- lvim.lsp.buffer_mappings.normal_mode['gt'] = { '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Goto type definition' }
-- lvim.lsp.buffer_mappings.normal_mode['go'] = { '<Cmd>lua vim.lsp.buf.incoming_calls()<CR>', 'Incoming calls' }
-- lvim.lsp.buffer_mappings.normal_mode['gO'] = { '<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>', 'Outgoing calls' }

-- telescope versions of some lsp mappings
lvim.lsp.buffer_mappings.normal_mode['gr'] = { '<Cmd>Telescope lsp_references<CR>', 'Telescope References' }
lvim.lsp.buffer_mappings.normal_mode['gd'] = { '<Cmd>Telescope lsp_definitions<CR>', 'Goto Definition' }
lvim.lsp.buffer_mappings.normal_mode['gI'] = { '<Cmd>Telescope lsp_implementations<CR>', 'Goto Implementation' }
lvim.lsp.buffer_mappings.normal_mode['gt'] = { '<Cmd>Telescope lsp_type_definitions<CR>', 'Goto Type Definition' }
lvim.lsp.buffer_mappings.normal_mode['go'] = { '<Cmd>Telescope lsp_incoming_calls<CR>', 'Incoming Calls' }
lvim.lsp.buffer_mappings.normal_mode['gO'] = { '<Cmd>Telescope lsp_outgoing_calls<CR>', 'Outgoing Calls' }
lvim.builtin.which_key.mappings['l']['d'] = { '<Cmd>Telescope diagnostics bufnr=0 theme=dropdown<CR>', 'Buffer Diagnostics' } -- use the dropdown theme

-- debugger mappings
lvim.builtin.which_key.vmappings['d'] = lvim.builtin.which_key.vmappings['d'] or { name = 'Debug' }
lvim.builtin.which_key.vmappings['d']['v'] = { function() require 'dapui'.eval() end, 'Eval Visual' }

lvim.builtin.which_key.mappings['d'] = lvim.builtin.which_key.mappings['d'] or {}
lvim.builtin.which_key.mappings['d']['s'] = { function() require 'dap'.continue() end, 'Start' }
lvim.builtin.which_key.mappings['d']['d'] = { function() require 'dap'.disconnect() end, 'Disconnect' }
lvim.builtin.which_key.mappings['d']['e'] = { function() vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input) require 'dap'.set_breakpoint(input) end) end, 'Expression Breakpoint' }
lvim.builtin.which_key.mappings['d']['L'] = { function() vim.ui.input({ prompt = 'Log point message: ' }, function(input) require 'dap'.set_breakpoint(nil, nil, input) end) end, 'Log on line' }
lvim.builtin.which_key.mappings['d']['h'] = { function() require 'dapui'.eval() end, 'Eval Hover' }
lvim.builtin.which_key.mappings['d']['q'] = { function() require('dap').terminate() end, 'Quit' }

lvim.builtin.which_key.mappings['L']['C'] = { '<Cmd>CmpStatus<CR>', 'Nvim-Cmp Status' }

-- lvim.builtin.which_key.mappings['h'] = nil -- I map this in hop.nvim
lvim.builtin.which_key.mappings[';'] = nil

-- lvim.builtin.which_key.mappings["g"]['g'].name = 'Tig'
lvim.builtin.which_key.mappings['g']['L'] = { '<Cmd>0Gclog<CR>', 'Git File Log' }
local are_diagnostics_visible = true
local toggle_diagnostics = function()
  are_diagnostics_visible = not are_diagnostics_visible
  if are_diagnostics_visible then vim.diagnostic.show() else vim.diagnostic.hide() end
end

lvim.builtin.which_key.mappings['l']['T'] = { toggle_diagnostics, 'Toggle Diagnostics' }
lvim.builtin.which_key.mappings['l']['f'] = { function() require 'lvim.lsp.utils'.format { timeout_ms = 30000 } end, 'Format' } -- give it more than 1 second (alternative: async=true)
lvim.builtin.which_key.vmappings['l'] = lvim.builtin.which_key.vmappings['l'] or { name = 'LSP' }
lvim.builtin.which_key.vmappings['l']['f'] = { function() require 'lvim.lsp.utils'.format { timeout_ms = 30000 } end, 'Format' } -- give it more than 1 second (alternative: async=true)

-- toggle contextive LSP {{{
local toggle_contextive = function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == 'contextive' then
      vim.cmd 'LspStop contextive'
      vim.cmd 'LspStart'
      return
    end
  end

  vim.cmd 'LspStop'
  vim.cmd 'LspStart contextive'
end

lvim.builtin.which_key.mappings['l']['C'] = { toggle_contextive, 'Toggle Contextive' }
-- }}}

-- auto hover definition {{{
lvim.lsp.hover_definition = false

---@param client_id integer
---@param bufnr integer
---@return nil
local enable_lsp_hover_definition = function(client_id, bufnr)
  local client_ok, method_supported = pcall(function()
    return vim.lsp.get_client_by_id(client_id).server_capabilities.hoverProvider
  end)

  if not client_ok or not method_supported then return end

  vim.api.nvim_create_augroup('lsp_hover_def', { clear = true })
  vim.api.nvim_create_autocmd('CursorHold', {
    group = 'lsp_hover_def',
    desc = 'lsp hover def',
    buffer = bufnr,
    -- local has_floating_window = vim.fn.len(vim.fn.filter(vim.api.nvim_list_wins(), function (_, v) return vim.api.nvim_win_get_config(v).relative ~= '' end)) > 0
    callback = function() if lvim.lsp.hover_definition then vim.lsp.buf.hover() end end, ---@diagnostic disable-line redundant-parameter
  })
end

local toggle_hover_def = function() lvim.lsp.hover_definition = not lvim.lsp.hover_definition end
lvim.builtin.which_key.mappings['l']['H'] = { toggle_hover_def, 'Toggle LSP Hover' }
vim.keymap.set('n', '<C-h>', toggle_hover_def, { noremap = true })
vim.keymap.set('i', '<C-h>', toggle_hover_def, { noremap = true })
-- }}}

-- Define an autocmd group for the blade workaround {{{
-- https://github.com/kauffinger/lazyvim/blob/e060b5503b87118a7ad164faed38dff3ec408f3e/lua/config/autocmds.lua#L5
-- TODO: this workaround does not work
local augroup_blade = vim.api.nvim_create_augroup("lsp_blade_workaround", { clear = true })

-- Autocommand to temporarily change 'blade' filetype to 'php' when opening for LSP server activation
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup_blade,
  pattern = "*.blade.php",
  callback = function()
    vim.bo.filetype = "php"
  end,
})

-- Additional autocommand to switch back to 'blade' after LSP has attached
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup_blade,
  pattern = "*.blade.php",
  callback = function(args)
    vim.schedule(function()
      -- Check if the attached client is 'intelephense'
      for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.name == "intelephense" and client.attached_buffers[args.buf] then
          vim.api.nvim_buf_set_option(args.buf, "filetype", "blade")
          break
        end
      end
    end)
  end,
})
-- }}}

-- put cursor at end of text on y and p
lvim.keys.visual_mode['y'] = 'y`]'
lvim.keys.visual_mode['p'] = 'p`]'
lvim.keys.normal_mode['p'] = 'p`]'

-- disable alt esc
lvim.keys.insert_mode['jk'] = nil
lvim.keys.insert_mode['kj'] = nil
lvim.keys.insert_mode['jj'] = nil

-- Wrapped lines goes down/up to next row, rather than next line in file.
vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { noremap = true, expr = true })

-- Easier horizontal scrolling
lvim.keys.normal_mode['zl'] = 'zL'
lvim.keys.normal_mode['zh'] = 'zH'

-- stupid f1 help
lvim.keys.normal_mode['<f1>'] = '<nop>'
lvim.keys.insert_mode['<f1>'] = '<nop>'

lvim.builtin.which_key.mappings['l']['a'] = { function() vim.lsp.buf.code_action() end, 'Code Action' } -- slightly prettier

-- visual lsp functions
lvim.builtin.which_key.vmappings['l'] = {
  name = 'LSP',
  a = { ":'<,'>lua vim.lsp.buf.code_action()<CR>", 'Code Action' },
  f = { ":'<,'>lua vim.lsp.buf.format()<CR>", 'Format' },
}

-- diffget for mergetool
-- (no longer) disabled in favor of akinsho/git-conflict.nvim
lvim.builtin.which_key.mappings['D'] = {
  name = 'DiffGet',
  l = { '<Cmd>diffget LOC<CR>', 'Use other branch' },
  r = { '<Cmd>diffget REM<CR>', 'Use current branch' },
  u = { '<Cmd>diffupdate<CR>', 'Update diff' },
}

lvim.builtin.which_key.mappings['b']['r'] = { '<Cmd>Telescope oldfiles<CR>', 'Recent' }

-- php

---@return nil
local php_splitter = function() vim.cmd [[exec "norm! 0/\\S->\<cr>a\<cr>\<esc>"]] end

---@return nil
local map_php_splitter = function()
  vim.keymap.set('n', ',.', php_splitter, { buffer = vim.api.nvim_get_current_buf(), noremap = true })
end
vim.api.nvim_create_augroup('php_splitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', { pattern = 'php', group = 'php_splitter', callback = map_php_splitter, desc = 'php splitter' })

---@return nil
local setup_php_leader_mappings = function()
  if not is_installed('which-key') then return end
  require 'which-key'.register({
    P = { name = 'Php',
      s = { '<Cmd>.,.s/\\/\\*\\* \\(.*\\) \\*\\//\\/\\*\\*\\r     * \\1\\r     *\\//g<cr>', 'Split docblock' },
      -- x = { '<Cmd>norm mv?array(<CR>f(mz%r]`zr[hvFa;d`v<CR>', 'Fix array' }, -- TODO: doesn't work because I can't type <c-v><enter>, neovim doesn't like it https://github.com/mikedfunk/dotfiles/blob/6800127ba60d66a3de72e7be84e008aa4425a2a2/.vimrc#L767
    }
  }, { prefix = '<Leader>' })
end
vim.api.nvim_create_augroup('php_leader_maps', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  group = 'php_leader_maps',
  callback = setup_php_leader_mappings,
  once = true,
  desc = 'php leader maps',
})

-- delete inactive buffers function {{{
-- TODO: convert to lua
-- @link http://stackoverflow.com/a/7321131/557215
vim.api.nvim_exec([[
function! DeleteInactiveBufs() abort
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let l:tablist = []
    for l:i in range(tabpagenr('$'))
        call extend(l:tablist, tabpagebuflist(l:i + 1))
    endfor

    let l:nWipeouts = 0
    for l:i in range(1, bufnr('$'))
        if bufexists(l:i) && !getbufvar(l:i,'&mod') && index(l:tablist, l:i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' l:i
            let l:nWipeouts = l:nWipeouts + 1
        endif
    endfor
    echomsg l:nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()
]], false)

lvim.builtin.which_key.mappings['b']['i'] = { ':call DeleteInactiveBufs()<CR>', 'Delete Inactive Buffers' }
-- }}}

lvim.builtin.which_key.mappings['l']['h'] = { function() vim.diagnostic.open_float() end, 'Line Diagnostic Hover' }

lvim.builtin.which_key.on_config_done = function()
  -- Comment.nvim
  require 'which-key'.register({
    b = { name = 'Comment', c = { 'Toggle blockwise comment' } },
    c = { name = 'Comment', c = { 'Toggle linewise comment' } },
  }, { prefix = 'g' })

  require 'which-key'.register({ b = { '<Cmd>BufferLineCycleNext<CR>', 'Next Buffer' } }, { prefix = ']' })
  require 'which-key'.register({ b = { '<Cmd>BufferLineCyclePrev<CR>', 'Previous Buffer' } }, { prefix = '[' })
  require 'which-key'.register({ B = { '<Cmd>BufferLineMoveNext<CR>', 'Move to Next Buffer' } }, { prefix = ']' })
  require 'which-key'.register({ B = { '<Cmd>BufferLineMovePrev<CR>', 'Move to Previous Buffer' } }, { prefix = '[' })
end

-- }}}

-- lvim lsp custom on_attach {{{

---@param client table
---@param bufnr integer
---@return nil
lvim.lsp.on_attach_callback = function(client, bufnr)
  vim.keymap.set('i', '<c-v>', function() vim.lsp.buf.signature_help() end, { buffer = bufnr, noremap = true })
  vim.keymap.set('i', '<c-k>', function() vim.lsp.buf.signature_help() end, { buffer = bufnr, noremap = true })

  if client.server_capabilities.document_formatting == true then
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})')
  end

  if client.server_capabilities.goto_definition == true then
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
  end

  enable_lsp_hover_definition(client.id, bufnr)
  plugins.symbols_outline_on_attach(client, bufnr)
  plugins.nvim_lightbulb_on_attach()
  plugins.lsp_inlayhints_on_attach(client, bufnr)
  plugins.document_color_nvim_on_attach(client, bufnr)
end
-- }}}

-- additional plugins {{{
-- having every plugin definition on one line makes it easy to comment out unused plugins and sort alphabetically.
lvim.plugins = {
  -- plugins.auto_dark_mode, -- auto switch color schemes, etc. based on macOS dark mode setting (better than cormacrelf/dark-notify)
  -- plugins.cmp_color_names, -- css color names like SteelBlue, etc.
  -- plugins.cmp_copilot, -- github copilot
  -- plugins.cmp_jira_issues_nvim, -- jira completion
  -- plugins.cmp_luasnip_choice, -- completion for luasnip choice nodes! better than a dedicated keyboard shortcut.
  -- plugins.cmp_nvim_lsp_document_symbol, -- helper to search for document symbols with /@ TODO: not quite working
  -- plugins.cmp_plugins, -- lua-only completion for neovim plugin repos, from github neovim topic!
  -- plugins.copilot_vim, -- github copilot
  -- plugins.definition_or_references_nvim, -- when on a definition, show references instead of jumping to itself on gd
  -- plugins.dial_nvim, -- extend <c-a> and <c-x> to work on other things too like bools, markdown headers, etc.
  -- plugins.incolla_nvim, -- paste images in markdown. configurable. Alternative: https://github.com/img-paste-devs/img-paste.vim
  -- plugins.laravel_nvim, -- laravel integration (TODO: our laravel version is too old to work with this)
  -- plugins.neodim, -- dim unused functions with lsp and treesitter (alternative: https://github.com/askfiy/lsp_extra_dim)
  -- plugins.noice_nvim, -- better cmdheight=0 with messages in notice windows, pretty more-prompt, etc. EEK causes all kinds of problems, try again later
  -- plugins.nvim_dap_tab, -- open nvim-dap in a separate tab so it doesn't fuck up my current buffer/split layout (2022-12-22 doesn't do anything :/ )
  -- plugins.nvim_femaco_lua, -- edit markdown code blocks with :Femaco (or <leader>me)
  -- plugins.nvim_hlslens, -- spiffy search UI, integrates with sidebar.nvim (it works fine, it's just too much visual kruf for me)
  -- plugins.nvim_spider, -- more natural `w,e,b`
  -- plugins.nvim_treesitter_playground, -- dev tool to help identify treesitter nodes and queries
  -- plugins.nvim_ufo, -- fancy folds
  -- plugins.nvim_various_textobjs, -- indent object and others (don't work as well as vim-indent-object)
  -- plugins.org_bullets, -- spiffy bullet icons and todo icons, adapted for use in markdown files
  -- plugins.tabout_nvim, -- tab to move out of parens, brackets, etc. Trying this out. You have to <c-e> from completion first. (I just don't use it.) TODO: replace with https://github.com/boltlessengineer/smart-tab.nvim
  -- plugins.text_case_nvim, -- lua replacement for vim-abolish, reword.nvim, and vim-camelsnek. DO NOT USE :'<'>Subs ! It does not just work on the visual selection!
  -- plugins.tmuxline_vim, -- tmux statusline generator (enable when generating)
  -- plugins.treesitter_indent_object_nvim, -- select in indentation level e.g. vii. I use this very frequently. Replaces vim-indent-object. Use with indent-blankline to preview what you're going to select.
  -- plugins.undotree, -- show a sidebar with branching undo history so you can redo on a different branch of changes TODO: replace with https://github.com/debugloop/telescope-undo.nvim ?
  -- plugins.vim_lion, -- align on operators like => like easy-align but works better `viiga=` TODO: replace with https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
  -- { 'HampusHauffman/block.nvim', cmd = { 'Block', 'BlockOn', 'BlockOff' }, opts = {}, dependencies = { 'nvim-treesitter/nvim-treesitter' } }, -- increased contrast for each treesitter block of code
  -- { 'LinArcX/telescope-env.nvim', event = 'VimEnter', dependencies = 'nvim-telescope/telescope.nvim', config = function() require 'telescope'.load_extension 'env' end }, -- telescope source for env vars
  -- { 'Wansmer/symbol-usage.nvim', event = 'BufReadPre', opts = {  request_pending_text= '', vt_position = 'end_of_line' } }, -- show virtual text with number of usages (this slows down the LSP in Zed especially)
  -- { 'ashfinal/qfview.nvim', event = 'UIEnter', opts = {} }, -- successor to nvim-pqf (This is like vim-lion for the quickfix. It pushes the right-most content way over, so I can't see as much of it.)
  -- { 'axelvc/template-string.nvim', ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } }, -- tiny plugin to convert literal strings to dynamic strings
  -- { 'esneider/YUNOcommit.vim', event = 'BufRead' }, -- u save lot but no commit. y u no commit?
  -- { 'folke/flash.nvim', event = 'BufRead', opts = {} }, -- easymotion-like clone by folke
  -- { 'fourjay/vim-hurl', event = 'VimEnter' }, -- hurl filetype and fold expression
  -- { 'jinh0/eyeliner.nvim', event = 'BufRead', opts = { highlight_on_key = true, dim = true } }, -- fFtT highlighter
  -- { 'lewis6991/foldsigns.nvim', event = 'BufRead', opts = {} }, -- show the most important sign hidden by a fold in the fold sign column (been crashing nvim lately)
  -- { 'mg979/vim-visual-multi', event = 'BufRead' }, -- multiple cursors with <c-n>, <c-up|down>, shift-arrow. Q to deselect. q to skip current and get next occurrence. TODO is this any better? https://github.com/smoka7/multicursors.nvim
  -- { 'nvim-treesitter/nvim-treesitter-context', event = 'BufRead' }, -- show current node at top of buffer
  -- { 'romgrk/nvim-treesitter-context', dependencies = 'nvim-treesitter/nvim-treesitter', event = 'BufRead', opts = {} }, -- show current context at the top of the page (function, if block, etc.) (I don't really need this any more with nvim-navic)
  -- { 'roobert/tabtree.nvim', event = 'VimEnter', opts = {} }, -- use treesitter to jump to various points such as "{()}" in normal mode (only works with certain treesitter queries that are for certain languages)
  -- { 'sindrets/diffview.nvim', cmd = 'DiffviewOpen' }, -- fancy diff view, navigator, and mergetool
  -- { 'tiagovla/scope.nvim', event = 'BufRead' }, -- scope buffers to tabs. This is only useful when I use tabs.
  -- { 'tomiis4/Hypersonic.nvim', cmd = 'Hypersonic' }, -- regex explainer
  -- { 'xiyaowong/virtcolumn.nvim', event = 'BufRead' }, -- line instead of bg color for colorcolumn. Arguable whether this is any better.
  -- { url = 'https://codeberg.org/esensar/nvim-dev-container', dependencies = 'nvim-treesitter/nvim-treesitter', config = function () require 'devcontainer'.setup({}) end }, -- devcontainer support
  -- { url = 'https://gitlab.com/itaranto/plantuml.nvim' }, -- plantuml previews
  -- { url = 'https://gitlab.com/yorickpeterse/nvim-pqf.git', event = 'BufRead', config = function() require 'pqf'.setup {} end }, -- prettier quickfix _line_ format (looks worse now)
  plugins.ale, -- older null-ls alternative
  plugins.backseat_nvim, -- Get suggestions from ChatGPT
  plugins.ccc_nvim, -- color picker, colorizer, etc.
  plugins.cmp_dap, -- completion source for dap stuff
  plugins.cmp_dictionary, -- vim dictionary source for cmp
  plugins.cmp_emoji, -- :)
  plugins.cmp_git, -- github source in commit messages for cmp e.g. users, PRs, hashes
  plugins.cmp_jira, -- jira completion
  plugins.cmp_nerdfont, -- like emoji completion but for nerd font characters
  plugins.cmp_nvim_lsp_signature_help, -- signature help using nvim-cmp. alternative to ray-x/lsp_signature.nvim . MUCH simpler, lighter weight, less buggy
  plugins.cmp_rg, -- might help to include comments, strings, etc. in other files. This is actually really useful! (makes expensive rg calls regularly, caught in htop)
  plugins.cmp_tabnine, -- AI completion (can hog memory/cpu)
  plugins.cmp_tmux, -- Add a tmux source to nvim-cmp (all text in all tmux windows/panes)
  plugins.cmp_treesitter, -- cmp completion source for treesitter nodes
  plugins.codeium_vim, -- like GitHub copilot but free
  plugins.dark_notify, -- auto-dark-mode
  plugins.document_color_nvim, -- tailwind color previewing
  plugins.dressing_nvim, -- spiff up vim.ui.select, etc.
  plugins.edgy_nvim, -- finally, a consolidated sidebar plugin! (alternative: https://github.com/stevearc/stickybuf.nvim)
  plugins.fold_preview_nvim, -- preview with h, open with h again
  plugins.goto_breakpoints_nvim, -- keymaps to go to next/prev breakpoint
  plugins.headlines_nvim, -- add markdown highlights
  plugins.lsp_inlayhints_nvim, -- cool virtual text type hints (not yet supported by any language servers I use except sumneko_lua )
  plugins.luasnip, -- add vscode snippet transformation support
  plugins.mason_null_ls_nvim, -- automatic installation and setup for null-ls via mason
  plugins.mini_align, -- align on operators like => `viiga=` replaces vim-lion
  plugins.mkdx, -- helpful markdown mappings
  plugins.modes_nvim, -- highlight UI elements based on current mode similar to Xcode vim bindings. Indispensable!
  plugins.neo_zoom_lua, -- zoom a window, especially helpful with nvim-dap-ui
  plugins.neoai_nvim, -- more ChatGPT stuff
  plugins.neoscroll_nvim, -- smooth scroller. Slower if you have relativenumber on. Animates zz|zt|zb, <c-d>|<c-u>|<c-f>|<c-b>, etc.
  plugins.notifier_nvim, -- notifications in bottom right for nvim and lsp, configurable, unobtrusive
  plugins.numb_nvim, -- preview jumping to line number
  plugins.nvim_bqf, -- add a preview for quickfix items! works faster with treesitter
  plugins.nvim_context_vt, -- like nvim-biscuits but execution is MUCH better
  plugins.nvim_dap_virtual_text, -- show variable value in virtual text
  plugins.nvim_lastplace, -- open files where you left off. Works!
  plugins.nvim_lightbulb, -- just show a lightbulb in the sign column when a code action is available (forked from kosayoda/nvim-lightbulb to fix an issue with ipairs)
  plugins.nvim_scrollbar, -- right side scrollbar that shows lsp diagnostics and looks good with tokyonight
  plugins.nvim_treesitter_endwise, -- wisely add "end" in lua, ruby, vimscript, etc.
  plugins.nvim_treesitter_textobjects, -- enable some more text objects for functions, classes, etc. also covers vim-swap functionality. (breaks in markdown! something about a bad treesitter query)
  plugins.nvim_ts_autotag, -- automatically close and rename html tags
  plugins.nvim_yati, -- better treesitter support for python and others
  plugins.persistent_breakpoints, -- persist breakpoints between sessions
  plugins.phpactor_nvim, -- Vim RPC refactoring plugin https://phpactor.readthedocs.io/en/master/vim-plugin/man.html (broken)
  plugins.range_highlight_nvim, -- live preview cmd ranges e.g. :1,2
  plugins.refactoring_nvim, -- refactoring plugin with telescope support
  plugins.splitjoin_vim, -- split and join php arrays to/from multiline/single line (gS, gJ) SO USEFUL! (see also: AckslD/nvim-trevJ.lua) TODO: replace with https://github.com/CKolkey/ts-node-action
  plugins.statuscol_nvim, -- use new statuscol feature for clickable fold signs, etc.
  plugins.surround_ui_nvim, -- which-key mappings for nvim-surround
  plugins.symbols_outline_nvim, -- alternative to aerial and vista.vim - show file symbols in sidebar TODO: replace with https://github.com/hedyhli/outline.nvim
  plugins.telescope_dap_nvim, -- helpful dap stuff like variables and breakpoints
  plugins.telescope_import_nvim, -- use telescope to ts/js import the same as was done before
  plugins.telescope_lazy_nvim, -- telescope source for lazy.nvim plugins
  plugins.telescope_undo_nvim, -- telescope replacement for undotree
  plugins.todo_comments_nvim, -- prettier todo, etc. comments, sign column indicators, and shortcuts to find them all in lsp-trouble or telescope
  plugins.ts_node_action, -- Split/Join functions, arrays, objects, etc with the help of treesitter
  plugins.typescript_nvim, -- advanced typescript lsp and null_ls features
  plugins.vim_abolish, -- No lazy load. I tried others but this is the only stable one so far (for :S)
  plugins.vim_fugitive, -- git and github integration. I really only need this for GBrowse, Git blame, y<C-g> etc.
  plugins.vim_git, -- Git file mappings and functions (e.g. rebase helpers like R, P, K) and syntax highlighting, etc. I add mappings in my plugin config.
  plugins.vim_jdaddy, --`gqaj` to pretty-print json, `gwaj` to merge the json object in the clipboard with the one under the cursor TODO: remove once I can replace with python -m json.tool from null-ls or whatever
  plugins.vim_matchup, -- better %
  plugins.vim_projectionist, -- link tests and classes together, etc. works with per-project .projections.json TODO: replace with https://github.com/gbprod/open-related.nvim or https://github.com/otavioschwanck/telescope-alternate.nvim or https://github.com/rgroli/other.nvim
  plugins.vim_startify, -- I really don't like alpha-nvim. It's handy to have the startify utf-8 box function. And I make use of the startify session segment and commands to have named per-project sessions. TODO: replace with https://github.com/olimorris/persisted.nvim
  plugins.vim_unimpaired, -- lots of useful, basic keyboard shortcuts
  plugins.zk_nvim, -- Zettelkasen notes tool
  { 'LiadOz/nvim-dap-repl-highlights', dependencies = { 'mfussenegger/nvim-dap', 'rcarriga/nvim-dap-ui' }, opts = {} }, -- dap REPL syntax highlighting (problem with auto insert mode)
  { 'aklt/plantuml-syntax', event = 'VimEnter' }, -- plantuml filetype
  { 'antosha417/nvim-lsp-file-operations', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-tree.lua' }, config = function() require('lsp-file-operations').setup() end }, -- enable lsp file-based code actions
  { 'boltlessengineer/smart-tab.nvim', event = 'InsertEnter', opts = {} }, -- replaces tabout.nvim. Tab to move out of parens, brackets, etc. You have to <c-e> from completion first.
  { 'felipec/vim-sanegx', keys = 'gx' }, -- open url with gx (alternative: https://github.com/chrishrb/gx.nvim)
  { 'fpob/nette.vim', event = 'VimEnter' }, -- syntax file for .neon format (not in polyglot as of 2021-03-26)
  { 'gbprod/php-enhanced-treesitter.nvim', branch = 'main', ft = 'php', dependencies = { 'nvim-treesitter/nvim-treesitter' } }, -- sql and regex included
  { 'gsuuon/tshjkl.nvim', config = true }, -- cool treesitter nav. <m-v> to toggle treesitter nav mode, then just hjkl or HJKL.
  { 'itchyny/vim-highlighturl', event = 'BufRead' }, -- just visually highlight urls like in a browser (now covered by tree-sitter-comment)
  { 'jghauser/mkdir.nvim', event = 'BufRead', config = function() require 'mkdir' end }, -- automatically create missing directories on save
  { 'jwalton512/vim-blade', event = 'VimEnter' }, -- old school laravel blade syntax
  { 'kylechui/nvim-surround', event = 'BufRead', opts = {} }, -- alternative to vim-surround and vim-sandwich
  { 'martinda/Jenkinsfile-vim-syntax', event = 'VimEnter' }, -- Jenkinsfile syntax highlighting
  { 'michaeljsmith/vim-indent-object', event = 'BufRead' }, -- select in indentation level e.g. vii. I use this very frequently. TODO: replace with https://github.com/kiyoon/treesitter-indent-object.nvim (replaced with chrisgrieser/nvim-various-textobjs)
  { 'nvim-zh/colorful-winsep.nvim', event = 'BufRead' }, -- just a clearer separator between windows (I don't need this)
  { 'rhysd/committia.vim', ft = 'gitcommit' }, -- prettier commit editor when git brings up the commit editor in vim. Really cool!
  { 'sickill/vim-pasta', event = 'BufRead' }, -- always paste with context-sensitive indenting. Tried this one, had lots of problems: https://github.com/hrsh7th/nvim-pasta
  { 'smjonas/live-command.nvim', event = 'BufRead', config = function ()  require 'live-command'.setup { commands = { Norm = { cmd = 'norm' } } } end }, -- preview norm commands with Norm
  { 'tpope/vim-apathy', ft = { 'lua', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'python' } }, -- tweak built-in vim features to allow jumping to javascript (and others like lua) module location with gf TODO: breaking with javascriptreact
  { 'tpope/vim-cucumber', event = 'VimEnter' }, -- gherkin filetype syntax highlighting (erroring out)
  { 'tpope/vim-eunuch', cmd = { 'Mkdir', 'Remove', 'Rename' } }, -- directory shortcuts TODO: replace with https://github.com/chrisgrieser/nvim-ghengis
  { 'wallpants/github-preview.nvim', cmd = { 'GithubPreviewStart', 'GithubPreviewToggle', 'GithubPreviewStop' }, opts = {} }, -- markdown preview (replaces iamcco/markdown-preview.nvim)
  { 'ziontee113/icon-picker.nvim', cmd = { 'IconPickerYank', 'IconPickerInsert', 'IconPickerNormal' }, dependencies = 'stevearc/dressing.nvim', opts = { disable_legacy_commands = true } }, -- find font characters, symbols, nerd font icons, and emojis
}
-- }}}
