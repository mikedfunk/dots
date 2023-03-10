-- vim: set foldmethod=marker:

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

-- https://www.reddit.com/r/neovim/comments/xx5hhp/introducing_livecommandnvim_preview_the_norm/
-- vim.o.splitkeep = "screen"

vim.o.spellfile = vim.fn.expand(vim.env.LUNARVIM_CONFIG_DIR .. '/spell/en.utf-8.add') -- this is necessary because nvim-treesitter is first in the runtimepath
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

  -- return start_line .. ' ??? ' .. end_line .. spaces
  return start_line .. ' ??? ' .. end_line .. spaces
end
vim.opt.foldtext = 'v:lua.simple_fold()'

-- I only need to set these when using code folding
-- vim.api.nvim_create_augroup('php_foldlevel', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', { pattern = 'php', group = 'php_foldlevel',
--   callback = function() vim.wo.foldlevel = 1 end,
-- })

-- vim.api.nvim_create_augroup('javascript_foldlevel', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', { pattern = 'javascript', group = 'javascript_foldlevel',
--   callback = function() vim.wo.foldlevel = 0 end,
-- })

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.api.nvim_create_augroup('hi_yanked_text', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'hi_yanked_text',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
  desc = 'highlight yanked text',
})

-- TODO: set cmdheight to 0 once this issue is fixed https://github.com/nvim-lualine/lualine.nvim/issues/853
vim.opt.cmdheight = 0 -- height of the bottom line that shows command output. I don't like lvim's default of 2.
vim.opt.showtabline = 1 -- show tabs only when more than one file
vim.o.inccommand = 'split' -- preview substitute in neovim `:h inccommand`
vim.o.foldcolumn = 'auto' -- make folds visible left of the sign column. Very cool ui feature!
-- vim.o.lazyredraw = true -- to speed up rendering and avoid scrolling problems (noice doesn't like this)
-- vim.o.hlsearch = false -- disable auto highlight all search results, this is handled by highlight-current-n
vim.o.pumblend = 15 -- popup pseudo-transparency
vim.o.winblend = 15 -- floating window pseudo-transparency
-- vim.o.exrc = true
-- vim.o.secure = true
-- vim.o.smartindent = true -- Do smart autoindenting when starting a new line. Absolute must.
-- vim.o.autoindent = true
vim.o.laststatus = 3 -- new neovim global statusline
if vim.fn.filereadable '/usr/share/dict/words' == 1 then vim.opt.dictionary:append('/usr/share/dict/words') end -- :h dictionary
-- vim.o.updatetime = 650 -- wait time before CursorHold activation
vim.o.updatetime = 100 -- wait time before CursorHold activation

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
vim.cmd 'set guicursor='

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

vim.api.nvim_create_autocmd('QUickFixCmdPost', { pattern = '[^l]*', group = 'last_quickfix', command = 'cwindow' })
vim.api.nvim_create_autocmd('QUickFixCmdPost', { pattern = 'l*', group = 'last_quickfix', command = 'lwindow' })

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

-- view uml diagram in browser {{{

---@return nil
local open_uml_image = function()
  local file_path = vim.fn.expand('%')
  if file_path == nil then return end
  vim.fn.system('plantuml ' .. file_path .. ' -tsvg')
  vim.fn.system('open ' .. file_path:gsub('%..-$', '.svg')) -- lua regex is weird
end

---@return nil
local refresh_uml_image = function()
  local file_path = vim.fn.expand('%')
  if file_path == nil then return end
  vim.fn.system('plantuml ' .. file_path .. ' -tsvg')
  vim.fn.system('$(brew --prefix)/bin/terminal-notifier -message "uml diagram reloaded"')
  -- vim.cmd('echom "UML diagram reloaded"')
end

---@return nil
local register_uml_mappings = function()
  if not is_installed('which-key') then return end

  require 'which-key'.register({
    i = {
      name = 'Image',
      o = { open_uml_image, 'Open' },
      r = { refresh_uml_image, 'Refresh' },
    }
  }, { prefix = '<Leader>' })
end

vim.api.nvim_create_augroup('uml_mappings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'plantuml',
  group = 'uml_mappings',
  callback = register_uml_mappings,
  desc = 'uml mappings',
})
-- }}}

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
  'nbsp:???',
  'tab:??????',
  'eol:???',
  'trail:???',
  'extends:??',
  'precedes:??',
  'trail:???',
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

-- use latest node version
vim.env.PATH = vim.fn.getenv('HOME') .. '/.asdf/installs/nodejs/17.8.0/bin:' .. vim.env.PATH

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
vim.api.nvim_create_augroup('unusual_filetypes', { clear = true })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '*.phtml', callback = function() vim.bo.filetype = 'phtml.html' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '*.eyaml', callback = function() vim.bo.filetype = 'yaml' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '.babelrc', callback = function() vim.bo.filetype = 'json' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '*.php.{sample,dist}', callback = function() vim.bo.filetype = 'php' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '{site,default}.conf', callback = function() vim.bo.filetype = 'nginx' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '.editorconfig', callback = function() vim.bo.filetype = 'dosini' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = 'Brewfile', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '.sshrc', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '.tigrc', callback = function() vim.bo.filetype = 'gitconfig' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '.{env,env.*}', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '*.{cnf,hurl}', callback = function() vim.bo.filetype = 'dosini' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '.spacemacs', callback = function() vim.bo.filetype = 'lisp' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', { group = 'unusual_filetypes', pattern = '.envrc', callback = function() vim.bo.filetype = 'sh' end })
vim.api.nvim_create_autocmd('BufRead,BufNewFile', {
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
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
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
lvim.icons.git.FileUnstaged = '???'
lvim.icons.git.FileUntracked = '???'
lvim.icons.git.FileStaged = '???'
-- }}}

-- language servers {{{
-- lvim.lsp.installer.setup.automatic_installation = { exclude = { 'phpactor' } }
-- NOTE: this is not just ensure installed, if these have language server
-- configs it will try to set them up as language servers. This is not what
-- I want for phpactor for instance. You must use the same keys as from
-- nvim-lspconfig. This does not include non-lsp tools.
--
-- when you run :LvimCacheReset
-- this will GENERATE an ftplugin to run lspconfig setup with no opts!
-- https://github.com/LunarVim/LunarVim/blob/30c65cfd74756954779f3ea9d232938e642bc07f/lua/lvim/lsp/templates.lua
lvim.lsp.installer.setup.ensure_installed = {
  'astro',
  'bashls',
  'cssls',
  'dockerls',
  'emmet_ls',
  'jsonls',
  'lemminx',
  'lua_ls', -- aka sumneko_lua
  'ruby_ls',
  'ruff_lsp', -- python linter lsp (replaces flake8)
  'svelte',
  'taplo',
  'vuels',
  'yamlls',
  'zk',
  -- 'cssmodules_ls',
  -- 'denols',
  -- 'emberls',
  -- 'eslint', -- eslint-lsp (stopped working on node 17.8.0, lsp debug isn't showing any errors)
  -- 'glint', -- typed ember
  -- 'graphql',
  -- 'intelephense', -- I customze the config
  -- 'nginx-language-server', -- not in lspconfig
  -- 'phpactor', -- I use intelephense instead
  -- 'prismals', -- node ORM
  -- 'pyright',
  -- 'relay_lsp', -- react framework
  -- 'remark-language-server', -- not in lspconfig
  -- 'solargraph',
  -- 'sqlls', -- https://github.com/joe-re/sql-language-server/issues/128
  -- 'sqls' -- just doesn't do anything, is archived
  -- 'tsserver', -- handled by typescript.nvim instead
  -- 'vimls',
}

lvim.lsp.diagnostics.signs.values[4].text = lvim.icons.diagnostics.Information
lvim.lsp.document_highlight = true

-- remove toml from skipped filetypes so I can configure taplo
lvim.lsp.automatic_configuration.skipped_filetypes = vim.tbl_filter(function(val)
  return not vim.tbl_contains({ 'toml' }, val)
end, lvim.lsp.automatic_configuration.skipped_filetypes)

for _, server in pairs({
  'intelephense',
  'phpactor',
  'tsserver',
}) do
  if not vim.tbl_contains(lvim.lsp.automatic_configuration.skipped_servers, server) then
    table.insert(lvim.lsp.automatic_configuration.skipped_servers, server)
  end
end

-- intelephense: moved to ./ftplugin/php.lua
-- flow: moved to ./ftplugin/javascript.lua
-- tsserver: moved to typescript.nvim
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

-- Bufferline tries to make everything italic. Why?
lvim.builtin.bufferline.highlights.background = { italic = false }
lvim.builtin.bufferline.highlights.buffer_selected.italic = false
lvim.builtin.bufferline.highlights.diagnostic_selected = { italic = false }
lvim.builtin.bufferline.highlights.hint_selected = { italic = false }
lvim.builtin.bufferline.highlights.hint_diagnostic_selected = { italic = false }
lvim.builtin.bufferline.highlights.info_selected = { italic = false }
lvim.builtin.bufferline.highlights.info_diagnostic_selected = { italic = false }
lvim.builtin.bufferline.highlights.warning_selected = { italic = false }
lvim.builtin.bufferline.highlights.warning_diagnostic_selected = { italic = false }
lvim.builtin.bufferline.highlights.error_selected = { italic = false }
lvim.builtin.bufferline.highlights.error_diagnostic_selected = { italic = false }
lvim.builtin.bufferline.highlights.duplicate_selected = { italic = false }
lvim.builtin.bufferline.highlights.duplicate_visible = { italic = false }
lvim.builtin.bufferline.highlights.duplicate = { italic = false }
lvim.builtin.bufferline.highlights.pick_selected = { italic = false }
lvim.builtin.bufferline.highlights.pick_visible = { italic = false }
lvim.builtin.bufferline.highlights.pick = { italic = false }

lvim.builtin.bufferline.options.persist_buffer_sort = true
lvim.builtin.bufferline.options.hover.enabled = true
lvim.builtin.bufferline.options.sort_by = 'insert_after_current'
lvim.builtin.bufferline.options.always_show_bufferline = true
lvim.builtin.bufferline.options.separator_style = 'slant'
-- lvim.builtin.bufferline.on_config_done = function()
--   vim.o.background = 'light'
-- end
-- }}}

-- gitsigns.nvim {{{

lvim.builtin.gitsigns.opts.yadm.enable = true

-- consistency with nvim-tree and makes more sense than the default
lvim.builtin.gitsigns.opts.signs.delete.text = '???'
lvim.builtin.gitsigns.opts.signs.topdelete.text = '???'
-- }}}

-- indent-blankline.nvim {{{
if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'mason') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'mason') end
if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') end
lvim.builtin.indentlines.options.show_first_indent_level = false
-- }}}

-- lualine {{{
lvim.builtin.lualine.style = 'default'
lvim.builtin.lualine.options.disabled_filetypes = { 'startify', 'TelescopePrompt' }
lvim.builtin.lualine.extensions = { 'quickfix', 'nvim-tree', 'symbols-outline', 'fugitive' } -- https://github.com/nvim-lualine/lualine.nvim#extensions

local components = require 'lvim.core.lualine.components'

components.filetype.on_click = function() vim.cmd 'Telescope filetypes' end

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
  icon = { '??', color = { fg = require 'lvim.core.lualine.colors'.blue } },
  color = { gui = 'None' },
  on_click = function() vim.cmd 'LspInfo' end,
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
  icon = { '???', color = { fg = require 'lvim.core.lualine.colors'.purple } },
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
  icon = { '???', color = { fg = require 'lvim.core.lualine.colors'.green } },
  cond = function() return is_installed 'cmp' and require 'lvim.core.lualine.conditions'.hide_in_width() end,
  on_click = function() vim.cmd 'CmpStatus' end,
}

---@return string
local dap_component = {
  function()
    local is_dap_installed, dap = pcall(require, 'dap')
    if is_dap_installed then return dap.status() else return '' end
  end,
  icon = { '???', color = { fg = require 'lvim.core.lualine.colors'.yellow } },
  cond = function()
    local is_dap_installed, dap = pcall(require, 'dap')
    return is_dap_installed and dap.status ~= ''
  end,
}

lvim.builtin.lualine.sections.lualine_x = {
  diagnostics_component,
  lsp_component,
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
  components.spaces,
  dap_component,
  search_count_component, -- useful for cmdheight=0
  macro_component,
}

-- }}}

-- luasnip {{{
if is_installed('luasnip') then
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

lvim.builtin.cmp.formatting.source_names['buffer'] = '???'
lvim.builtin.cmp.formatting.source_names['buffer-lines'] = '???'
lvim.builtin.cmp.formatting.source_names['calc'] = '???'
lvim.builtin.cmp.formatting.source_names['cmp_tabnine'] = '???' -- ???
lvim.builtin.cmp.formatting.source_names['color_names'] = '(Colors)'
lvim.builtin.cmp.formatting.source_names['dap'] = '???'
lvim.builtin.cmp.formatting.source_names['dictionary'] = '???'
lvim.builtin.cmp.formatting.source_names['doxygen'] = '@'
lvim.builtin.cmp.formatting.source_names['emoji'] = '???'
lvim.builtin.cmp.formatting.source_names['git'] = '???'
lvim.builtin.cmp.formatting.source_names['luasnip'] = '???'
lvim.builtin.cmp.formatting.source_names['marksman'] = '????'
lvim.builtin.cmp.formatting.source_names['nvim_lsp'] = '??'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_signature_help'] = '??'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_document_symbol'] = '??'
lvim.builtin.cmp.formatting.source_names['nvim_lua'] = '???'
lvim.builtin.cmp.formatting.source_names['path'] = '???'
lvim.builtin.cmp.formatting.source_names['path'] = '???'
lvim.builtin.cmp.formatting.source_names['plugins'] = '???'
lvim.builtin.cmp.formatting.source_names['rg'] = '???'
lvim.builtin.cmp.formatting.source_names['tmux'] = '???'
lvim.builtin.cmp.formatting.source_names['treesitter'] = '???'
lvim.builtin.cmp.formatting.source_names['vsnip'] = '???'
lvim.builtin.cmp.formatting.source_names['zk'] = '???'

lvim.builtin.cmp.formatting.kind_icons.Method = lvim.icons.kind.Method -- default is ???
lvim.builtin.cmp.formatting.kind_icons.Function = lvim.icons.kind.Function -- default is ??

local is_cmp_installed, cmp = pcall(require, 'cmp')
if is_cmp_installed then lvim.builtin.cmp.preselect = cmp.PreselectMode.None end
lvim.builtin.cmp.mapping['<C-J>'] = lvim.builtin.cmp.mapping['<Tab>']
lvim.builtin.cmp.mapping['<C-K>'] = lvim.builtin.cmp.mapping['<S-Tab>']

-- lvim.builtin.cmp.mapping['<C-Y>'] = function() require 'cmp'.mapping.confirm({ select = false }) end -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
-- }}}

-- null-ls {{{
lvim.lsp.null_ls.setup.debounce = 1000
lvim.lsp.null_ls.setup.default_timeout = 30000
local is_null_ls_installed, null_ls = pcall(require, 'null-ls') ---@diagnostic disable-line redefined-local
-- lvim.lsp.null_ls.setup.debug = true -- turn on debug null-ls logging: tail -f ~/.cache/nvim/null-ls.log

-- linters {{{

require 'lvim.lsp.null-ls.linters'.setup {
  {
    name = 'codespell',
    -- force the severity to be HINT
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity.HINT
    end,
    extra_args = { '--ignore-words-list', 'tabe,noice' },
  },
  -- { name = 'mypy', condition = function() return vim.fn.executable 'mypy' == 1 end }, -- disabled for ruff instead
  -- { name = 'pycodestyle', condition = function() return vim.fn.executable 'pycodestyle' == 1 end }, -- disabled for ruff instead
  -- { name = 'dotenv_linter' }, -- not available in Mason
  -- { name = 'luacheck' },
  { name = 'eslint_d' }, -- until I can get the eslint-lsp to work again
  { name = 'gitlint' },
  {
    name = 'shellcheck',
    condition = function() return not vim.tbl_contains({'.env', '.env.example'}, vim.fn.expand('%:t')) end,
  },
  { name = 'editorconfig_checker', filetypes = { 'editorconfig' } },
  -- { name = 'checkmake' }, -- makefile linter
  {
    name = 'phpcs',
    timeout = 30000,
    extra_args = {
      '--cache',
      '--warning-severity=3',
      '-d',
      'memory_limit=100M',
      '-d',
      'xebug.mode=off',
    },
    condition = function(utils)
      return vim.fn.executable 'phpcs' == 1 and utils.root_has_file { 'phpcs.xml' }
    end,
  },
  {
    name = 'phpstan',
    timeout = 30000,
    extra_args = {
      '--memory-limit=200M',
      -- '--configuration=' .. vim.api.nvim_exec('pwd', true) .. '/phpstan.neon',
    }, -- 40MB is not enough
    condition = function(utils)
      return utils.root_has_file { 'phpstan.neon' }
      -- return vim.fn.executable('phpstan') == 1 and vim.fn.filereadable 'phpstan.neon' == 1
    end,
  },
  { name = 'php' },
  { name = 'rubocop' },
  { name = 'sqlfluff', extra_args = { '--dialect', 'mysql' } },
  -- { name = 'trail_space' },
  { name = 'zsh' },
}

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
  --   command = vim.fn.getenv('HOME') .. '/.support/phpcbf-helper.sh', -- damn it... they override the command now. Gotta do it from null-ls instead. https://github.com/lunarvim/lunarvim/blob/c18cd3f0a89443d4265f6df8ce12fb89d627f09e/lua/lvim/lsp/null-ls/services.lua#L81
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
    name = 'rustywind', -- tailwind helper
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
      command = vim.fn.getenv('HOME') .. '/.support/phpcbf-helper.sh', -- damn it... they override the command now. Gotta do it from null-ls instead.
      extra_args = { '-d', 'memory_limit=60M', '-d', 'xdebug.mode=off', '--warning-severity=0' }, -- do not fix warnings
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
  { name = 'eslint_d' }, -- until I can get eslint-lsp to start working
  { name = 'gitrebase' }, -- just provides helpers to switch pick to fixup, etc.
  { name = 'refactoring' },
  { name = 'proselint' }, -- trying this out for markdown
  -- adds a LOT of null-ls noise, not that useful
  -- {
  --   name = 'gitsigns',
  --   condition = function() return is_installed 'gitsigns' end,
  -- },
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

  dap.adapters.node2 = {
    type = 'executable',
    command = 'node2-debug-adapter', -- this calls the same thing below
    -- command = 'node',
    -- args = { mason_path .. '/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  }
end

local adjust_dap_signs = function()
  -- vim.fn.sign_define('DapBreakpoint', { text = '???', texthl = 'debugPC', linehl = 'debugPC', numhl = 'debugPC' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '???', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
  -- vim.fn.sign_define('DapStopped', { text = '???', texthl = 'debugBreakpoint', linehl = 'debugBreakpoint', numhl = 'debugBreakpoint' })
end

lvim.builtin.dap.on_config_done = function()
  register_dap_adapters()
  adjust_dap_signs()
end

require 'saatchiart.plugin_configs'.configure_nvim_dap()

-- }}}

-- nvim-navic {{{
-- https://github.com/SmiteshP/nvim-navic#%EF%B8%8F-setup
vim.g.navic_silence = true
-- lvim.builtin.breadcrumbs.options.separator = ' ' .. lvim.icons.ui.ChevronShortRight .. ' ' -- bug: this is only used for the _second_ separator and beyond https://github.com/LunarVim/LunarVim/blob/ea9b648a52de652a972471083f1e1d67f03305fa/lua/lvim/core/breadcrumbs.lua#L160
-- }}}

-- nvim-tree {{{

-- https://github.com/kyazdani42/nvim-tree.lua/issues/674
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

if not vim.tbl_contains(lvim.builtin.nvimtree.setup.filters.custom, '.git') then table.insert(lvim.builtin.nvimtree.setup.filters.custom, '.git') end
-- }}}

-- nvim-treesitter {{{
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { 'php' } -- needed to make non-treesitter indent work

vim.api.nvim_create_augroup('treesitter_foldexpr', { clear = true })
vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = table.concat({
      'php',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'ruby',
      'python',
      'go',
    }, ','),
    group = 'treesitter_foldexpr',
    callback = function()
      if vim.wo.foldmethod == 'marker' then return end
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.wo.foldlevel = 99
    end,
  }
)

lvim.builtin.treesitter.ensure_installed = {
  'comment',
  'lua', -- update to latest
  'markdown_inline',
  'phpdoc',
  'regex', -- used by php-enhanced-treesitter
  'sql', -- used by php-enhanced-treesitter
  'vim', -- MUST update from the built-in or my config will cause problems when trying to display
}

lvim.builtin.treesitter.context_commentstring.config.gitconfig = '# %s'
lvim.builtin.treesitter.context_commentstring.config.sql = '-- %s'

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
--   command = 'tsbufdisable incremental_selection'
-- })

lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.context_commentstring.config['php'] = '// %s'

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
end

-- }}}

-- project.nvim {{{
if not vim.tbl_contains(lvim.builtin.project.patterns, 'composer.json') then table.insert(lvim.builtin.project.patterns, 'composer.json') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'config.lua') then table.insert(lvim.builtin.project.patterns, 'config.lua') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'bootstrap') then table.insert(lvim.builtin.project.patterns, 'bootstrap') end
-- }}}

-- telescope.nvim {{{

lvim.builtin.telescope.defaults.prompt_prefix = ' ' .. lvim.icons.ui.Search .. ' ' -- ??? ???
lvim.builtin.telescope.defaults.winblend = 15 -- pseudo-transparency
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
lvim.builtin.theme.tokyonight.options.style = 'moon'
-- lvim.builtin.theme.tokyonight.options.style = 'night'

lvim.builtin.theme.tokyonight.options.dim_inactive = true -- dim inactive windows
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- bold headers for each section header
lvim.builtin.theme.tokyonight.options.sidebars = { 'NvimTree', 'aerial', 'Outline', 'DapSidebar', 'UltestSummary', 'dap-repl' }
-- lvim.builtin.theme.tokyonight.options.day_brightness = 0.05 -- high contrast
lvim.builtin.theme.tokyonight.options.day_brightness = 0.15 -- high contrast but colorful
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- section headers in lualine theme will be bold
lvim.builtin.theme.tokyonight.options.hide_inactive_statusline = true
-- vim.cmd 'silent! hi! link TabLineFill BufferLineGroupSeparator' -- temp workaround to bufferline background issue
-- }}}

-- which-key.nvim {{{
-- lvim.builtin.which_key.opts.nowait = false
-- lvim.builtin.which_key.vopts.nowait = false
lvim.builtin.which_key.setup.icons.group = '??? '
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

-- BufOnly.nvim {{{
plugins.bufonly_nvim = {
  'numToStr/BufOnly.nvim',
  cmd = 'BufOnly',
  init = function()
    lvim.builtin.which_key.mappings['b']['o'] = { '<Cmd>BufOnly<CR>', 'Delete All Other Buffers' }
  end,
}
-- }}}

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
  dependencies = { 'hrsh7th/nvim-cmp', 'hrsh7th/cmp-cmdline' },
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
      default_prompt = '??? ', -- ??? ???
    },
  },
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
      ['-'] = { name = '??? Checkbox State' },
      ['<Leader>'] = { name = '??? Checkbox State' },
      ['='] = { name = '??? Checkbox State' },
      ['/'] = { name = 'Italic' },
      ['['] = { name = '??? Header' },
      [']'] = { name = '??? Header' },
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
      ['-'] = { name = '??? Checkbox State' },
      ['='] = { name = '??? Checkbox State' },
      ['/'] = { name = 'Italic' },
      ['['] = { name = '??? Header' },
      [']'] = { name = '??? Header' },
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
  ft = { 'dapui_.*', 'dap-repl' },
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
  config = function() require 'bqf'.setup {} end,
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
      return '??? ' .. vim.treesitter.query.get_node_text(node, 0)[1]
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
  init = function()
    vim.fn.sign_define('LightBulbSign', { text = '???', texthl = 'DiagnosticSignWarn' })
  end,
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
      --   Search = { color = colors.orange }, -- doesn't seem to work :/
      -- },
    })
  end,
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
      ['<leader>lC'] = '@class.outer',
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
  require 'which-key'.register({
    l = {
      ['C'] = 'Peek Class Definition',
      -- ['F'] = 'Peek Function Definition',
    }
  }, { prefix = '<Leader>' })
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
    'phtml.html',
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
  init = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require 'which-key'.register({
      R = { function() require('ufo').openAllFolds() end, 'Open All Folds' },
      M = { function() require('ufo').closeAllFolds() end, 'Close All Folds' },
      r = { function() require('ufo').closeFoldsExceptKinds() end, 'Close Folds Except Kinds' },
      m = { function() require('ufo').closeFoldsWith() end, 'Close Folds With' },
    }, { prefix = 'z' })

    -- require 'which-key'.register({
    --   K = { function() require('ufo').peekFoldedLinesUnderCursor() end, 'Preview Fold' },
    -- }, { prefix = 'g' })
  end,
  opts = {
    provider_selector = function(_, _, _)
      return { 'treesitter', 'indent' }
    end,
    -- preview = {
    --   win_config = {
    --     -- border = { '', '???', '', '', '', '???', '', '' },
    --     -- winhighlight = 'Normal:Folded',
    --     win_blend = 0,
    --   },
    -- },
    mappings = {
      scrollU = '<C-u>',
      scrollD = '<C-d>',
    },
  }
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
  local php_bin_path = vim.fn.getenv('HOME') .. '/.asdf/installs/php/8.2.0/bin'
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
  'gbprod/phpactor.nvim',
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

-- surround-ui.nvim {{{
plugins.surround_ui_nvim = {
  'roobert/surround-ui.nvim',
  dependencies = {
    'kylechui/nvim-surround',
    'folke/which-key.nvim',
  },
  opts = {
    root_key = 'S'
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
    relative_width = false,
    auto_close = true,
    winblend = vim.o.winblend,
    -- highlight_hovered_item = false,
    -- auto_preview = true,
    autofold_depth = 2,
    auto_unfold_hover = false,
    -- possible values https://github.com/simrat39/symbols-outline.nvim/blob/master/lua/symbols-outline/symbols.lua
    -- symbol_blacklist = {
    --   -- works best for object-oriented code
    --   'Field',
    --   'Function',
    --   'Key',
    --   'Variable',
    -- },
    symbols = {
      Class = { icon = lvim.icons.kind.Class },
      Constant = { icon = lvim.icons.kind.Constant },
      Constructor = { icon = lvim.icons.kind.Constructor },
      Enum = { icon = lvim.icons.kind.Enum },
      EnumMember = { icon = lvim.icons.kind.EnumMember },
      File = { icon = lvim.icons.kind.File },
      Function = { icon = lvim.icons.kind.Function },
      Interface = { icon = lvim.icons.kind.Interface },
      Method = { icon = lvim.icons.kind.Method },
      Module = { icon = lvim.icons.kind.Module },
      Property = { icon = lvim.icons.kind.Property },
      Struct = { icon = lvim.icons.kind.Struct },
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

plugins.tmuxline_vim = {
  'edkolev/tmuxline.vim',
  cmd = { 'Tmuxline', 'TmuxlineSnapshot' },
  init = function()
    vim.g['tmuxline_preset'] = {
      a = { '#S' }, -- session name ???|???
      c = {
        table.concat({
          '#{cpu_fg_color}#{cpu_icon}#[fg=default]',
          '#{ram_fg_color}#{ram_icon}#[fg=default]',
          '#{battery_color_charge_fg}#{battery_icon_charge}#[bg=colour236]#[fg=default]',
          '#{wifi_icon}',
        }, ' '),
        '#(~/.support/tmux-docker-status.sh)',
      },
      win = { '#I', '#W#{?window_bell_flag, ???,}#{?window_zoomed_flag, ???,}' }, -- unselected tab
      cwin = { '#I', '#W#{?window_zoomed_flag, ???,}' }, -- current tab
      x = { "#(TZ=Etc/UTC date '+%%R UTC')" }, -- UTC time
      y = { '%l:%M %p' }, -- local time
      z = { '%a', '%b %d' }, -- local date
    }

    -- dark
    -- vim.g['tmuxline_theme'] = {
    --   a = { '16', '254', 'bold' },
    --   b = { '237', '240' },
    --   c = { '247', '236'},
    --   x = { '250', '232' },
    --   y = { '247', '236'},
    --   z = { '235', '252' },
    --   bg = { '247', '234'},
    --   win = { '250', '234' },
    --   ['win.dim'] = { '244', '234' },
    --   cwin = { '231', '31', 'bold' },
    --   ['cwin.dim'] = { '117', '31' },
    -- }

    -- light
    -- vim.g['tmuxline_theme'] = {
    --   a = { '250', '232', 'bold' },
    --   b = { '247', '236' },
    --   c = { '247', '234'},
    --   x = { '247', '234' },
    --   y = { '247', '236'},
    --   z = { '250', '232' },
    --   bg = { '16', '254'},
    --   win = { '16', '254' },
    --   cwin = { '231', '31', 'bold' },
    -- }

    vim.cmd 'command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.config/tmux/tmuxline-dark.conf' -- apply tmuxline settings and snapshot to file
  end,
}
-- }}}

-- ts-node-action {{{
plugins.ts_node_action = {
  'CKolkey/ts-node-action',
  ft = {
    'php',
    'lua',
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'python',
    'ruby',
  },
  dependencies = 'folke/which-key.nvim',
  config = function()
    local padding = {
      [','] = '%s',
      ['=>'] = ' %s ',
      ['='] = '%s',
      ['['] = '%s',
      [']'] = '%s',
      ['}'] = '%s',
      ['{'] = '%s',
      ['||'] = ' %s ',
      ['&&'] = ' %s ',
      ['.'] = ' %s ',
      ['+'] = ' %s ',
      ['*'] = ' %s ',
      ['-'] = ' %s ',
      ['/'] = ' %s ',
    }
    local toggle_multiline = require('ts-node-action.actions.toggle_multiline')(padding)
    require 'ts-node-action'.setup {
      php = {
        array_creation_expression = toggle_multiline,
        formal_parameters = toggle_multiline,
        arguments = toggle_multiline,
        subscript_expression = toggle_multiline,
      }
    }
    if not is_installed('which-key') then return end
    require 'which-key'.register({
      J = {
        function() require 'ts-node-action'.node_action() end,
        'Split/Join'
      },
    }, { prefix = 'g' })
  end,
}
-- }}}

-- typescript.nvim {{{
plugins.typescript_nvim = {
  'jose-elias-alvarez/typescript.nvim',
  dependencies = 'jose-elias-alvarez/null-ls.nvim',
  ft = {
    -- 'javascript',
    'typescript',
    'typescriptreact',
  },
  config = function()
    require 'typescript'.setup {
      server = {
        on_attach = require 'lvim.lsp'.common_on_attach,
        on_init = require 'lvim.lsp'.common_on_init,
        on_exit = require 'lvim.lsp'.common_on_exit,
        capabilities = require 'lvim.lsp'.common_capabilities(),
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
  cmd = 'UndotreeToggle',
  init = setup_undotree,
}
-- }}}

-- vim-abolish {{{
plugins.vim_abolish = {
  'tpope/vim-abolish',
  init = function()
    vim.g.abolish_no_mappings = 1
    vim.g.abolish_save_file = vim.fn.getenv('LUNARVIM_RUNTIME_DIR') .. '/after/plugin/abolish.vim'
  end,
  config = function()
    vim.cmd('Abolish colleciton ollection')
    vim.cmd('Abolish connecitno connection')
    vim.cmd('Abolish conneciton connection')
    vim.cmd('Abolish couchbsae couchbase')
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
  init = function() vim.g['lion_map_right'] = 'ga' end,
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
    -- vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
    -- vim.g.matchup_matchparen_deferred = 1
    -- vim.g.matchup_matchparen_hi_surround_always = 1
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
  vim.g['startify_session_dir'] = vim.fn.getenv('HOME') .. '/.local/share/lunarvim/session' .. vim.fn.getcwd() -- session dir for each repo
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
    d = { '<Cmd>SDelete<CR>', 'Delete' },
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
lvim.builtin.which_key.mappings['E'] = { '<Cmd>NvimTreeToggle<CR>', 'Explore' }

lvim.builtin.which_key.mappings['l']['c'] = { '<Cmd>LspSettings buffer<CR>', 'Configure LSP' }
lvim.builtin.which_key.mappings['l']['R'] = { '<Cmd>LspRestart<CR>', 'Restart LSP' }

lvim.builtin.which_key.mappings['b']['d'] = { '<Cmd>bd<CR>', 'Delete' }
lvim.builtin.which_key.mappings['b']['p'] = { '<Cmd>BufferLineTogglePin<CR>', 'Pin/Unpin' }

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
lvim.builtin.which_key.vmappings['d']['h'] = { function() require 'dapui'.eval() end, 'Eval Visual' }

lvim.builtin.which_key.mappings['d'] = lvim.builtin.which_key.mappings['d'] or {}
lvim.builtin.which_key.mappings['d']['s'] = { function() require 'dapui'.open(); require 'dap'.continue() end, 'Start' }
lvim.builtin.which_key.mappings['d']['d'] = { function() require 'dap'.disconnect() end, 'Disconnect' }
lvim.builtin.which_key.mappings['d']['e'] = { function() vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input) require 'dap'.set_breakpoint(input) end) end, 'Expression Breakpoint' }
lvim.builtin.which_key.mappings['d']['L'] = { function() vim.ui.input({ prompt = 'Log point message: ' }, function(input) require 'dap'.set_breakpoint(nil, nil, input) end) end, 'Log on line' }
lvim.builtin.which_key.mappings['d']['q'] = { function()
  require('dap').close();
  require('dapui').close({ reset = true })
end, 'Quit' }

lvim.builtin.which_key.mappings['L']['C'] = { '<Cmd>CmpStatus<CR>', 'Nvim-Cmp Status' }

-- lvim.builtin.which_key.mappings['h'] = nil -- I map this in hop.nvim
lvim.builtin.which_key.mappings[';'] = nil

-- lvim.builtin.which_key.mappings["g"]['g'].name = 'Tig'
local are_diagnostics_visible = true
local toggle_diagnostics = function()
  are_diagnostics_visible = not are_diagnostics_visible
  if are_diagnostics_visible then vim.diagnostic.show() else vim.diagnostic.hide() end
end

lvim.builtin.which_key.mappings['l']['T'] = { toggle_diagnostics, 'Toggle Diagnostics' }
lvim.builtin.which_key.mappings['l']['f'] = { function() require 'lvim.lsp.utils'.format { timeout_ms = 30000 } end, 'Format' } -- give it more than 1 second (alternative: async=true)
lvim.builtin.which_key.vmappings['l'] = lvim.builtin.which_key.vmappings['l'] or { name = 'LSP' }
lvim.builtin.which_key.vmappings['l']['f'] = { function() require 'lvim.lsp.utils'.format { timeout_ms = 30000 } end, 'Format' } -- give it more than 1 second (alternative: async=true)

-- hover definition {{{
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
    callback = function() if lvim.lsp.hover_definition then vim.lsp.buf.hover() end end, ---@diagnostic disable-line redundant-parameter
  })
end

local toggle_hover_def = function() lvim.lsp.hover_definition = not lvim.lsp.hover_definition end
lvim.builtin.which_key.mappings['l']['H'] = { toggle_hover_def, 'Toggle LSP Hover' }
vim.keymap.set('n', '<C-h>', toggle_hover_def, { noremap = true })
vim.keymap.set('i', '<C-h>', toggle_hover_def, { noremap = true })
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
  -- plugins.cmp_color_names, -- css color names like SteelBlue, etc.
  -- plugins.cmp_nvim_lsp_document_symbol, -- helper to search for document symbols with /@ TODO: not quite working
  -- plugins.noice_nvim, -- better cmdheight=0 with messages in notice windows, pretty more-prompt, etc. EEK causes all kinds of problems, try again later
  -- plugins.nvim_dap_tab, -- open nvim-dap in a separate tab so it doesn't fuck up my current buffer/split layout (2022-12-22 doesn't do anything :/ )
  -- plugins.nvim_hlslens, -- spiffy search UI, integrates with sidebar.nvim (it works fine, it's just too much visual kruf for me)
  -- plugins.nvim_treesitter_playground, -- dev tool to help identify treesitter nodes and queries
  -- plugins.nvim_ufo, -- fancy folds (probably better with LSP integration, which is a little hard to accomplish with Lunarvim)
  -- plugins.nvim_various_textobjs, -- indent object and others (don't work as well as vim-indent-object)
  -- plugins.text_case_nvim, -- lua replacement for vim-abolish, reword.nvim, and vim-camelsnek. DO NOT USE :'<'>Subs ! It does not just work on the visual selection!
  -- plugins.tmuxline_vim, -- tmux statusline generator (enable when generating)
  -- plugins.ts_node_action, -- Split/Join functions, arrays, objects, etc with the help of treesitter (TODO: not available for PHP yet)
  -- { 'echasnovski/mini.animate', event = 'VimEnter' }, -- animate <c-d>, zz, <c-w>v, etc. (neoscroll does most of this and better)
  -- { 'esneider/YUNOcommit.vim', event = 'BufRead' }, -- u save lot but no commit. y u no commit?
  -- { 'jwalton512/vim-blade', event = 'VimEnter' }, -- old school laravel blade syntax
  -- { 'lukas-reineke/virt-column.nvim', event = 'BufRead', opts = {} }, -- line instead of bg color for colorcolumn. Arguable whether this is any better.
  -- { 'm4xshen/smartcolumn.nvim', opts = { colorcolumn = "80,120" }}, -- only show colorcolumn when it's exceeded (TODO: doesn't work for multiple)
  -- { 'sindrets/diffview.nvim', cmd = { 'DiffviewOpen' }, requires = 'nvim-lua/plenary.nvim' }, -- fancy diff view, navigator, and mergetool
  -- { 'tiagovla/scope.nvim', event = 'BufRead' }, -- scope buffers to tabs. This is only useful when I use tabs.
  -- { url = 'https://gitlab.com/yorickpeterse/nvim-pqf.git', event = 'BufRead', config = function() require 'pqf'.setup {} end }, -- prettier quickfix _line_ format (looks worse now)
  plugins.auto_dark_mode, -- auto switch color schemes, etc. based on macOS dark mode setting (better than cormacrelf/dark-notify)
  plugins.bufonly_nvim, -- close all buffers but the current one
  plugins.ccc_nvim, -- color picker, colorizer, etc.
  plugins.cmp_dap, -- completion source for dap stuff
  plugins.cmp_dictionary, -- vim dictionary source for cmp
  plugins.cmp_emoji, -- :)
  plugins.cmp_git, -- github source in commit messages for cmp e.g. users, PRs, hashes
  plugins.cmp_nvim_lsp_signature_help, -- signature help using nvim-cmp. alternative to ray-x/lsp_signature.nvim . MUCH simpler, lighter weight, less buggy
  plugins.cmp_plugins, -- lua-only completion for neovim plugin repos, from github neovim topic!
  plugins.cmp_rg, -- might help to include comments, strings, etc. in other files. This is actually really useful! (makes expensive rg calls regularly, caught in htop)
  plugins.cmp_tabnine, -- AI completion (can hog memory/cpu)
  plugins.cmp_tmux, -- Add a tmux source to nvim-cmp (all text in all tmux windows/panes)
  plugins.cmp_treesitter, -- cmp completion source for treesitter nodes
  plugins.dial_nvim, -- extend <c-a> and <c-x> to work on other things too like bools, markdown headers, etc.
  plugins.document_color_nvim, -- tailwind color previewing
  plugins.dressing_nvim, -- spiff up vim.ui.select, etc.
  plugins.fold_preview_nvim, -- preview with h, open with h again
  plugins.goto_breakpoints_nvim, -- keymaps to go to next/prev breakpoint
  plugins.headlines_nvim, -- add markdown highlights
  plugins.incolla_nvim, -- paste images in markdown. configurable. Alternative: https://github.com/img-paste-devs/img-paste.vim
  plugins.lsp_inlayhints_nvim, -- cool virtual text type hints (not yet supported by any language servers I use except sumneko_lua )
  plugins.mason_null_ls_nvim, -- automatic installation and setup for null-ls via mason
  plugins.mkdx, -- helpful markdown mappings
  plugins.modes_nvim, -- highlight UI elements based on current mode similar to Xcode vim bindings. Indispensable!
  plugins.neo_zoom_lua, -- zoom a window, especially helpful with nvim-dap-ui
  plugins.neodim, -- dim unused functions with lsp and treesitter
  plugins.neoscroll_nvim, -- smooth scroller. Slower if you have relativenumber on. Animates zz|zt|zb, <c-d>|<c-u>|<c-f>|<c-b>, etc.
  plugins.notifier_nvim, -- notifications in bottom right for nvim and lsp, configurable, unobtrusive
  plugins.numb_nvim, -- preview jumping to line number
  plugins.nvim_bqf, -- add a preview for quickfix items! works faster with treesitter
  plugins.nvim_context_vt, -- like nvim-biscuits but execution is MUCH better
  plugins.nvim_dap_virtual_text, -- show variable value in virtual text
  plugins.nvim_femaco_lua, -- edit markdown code blocks with :Femaco (or <leader>me)
  plugins.nvim_lightbulb, -- just show a lightbulb in the sign column when a code action is available (forked from kosayoda/nvim-lightbulb to fix an issue with ipairs)
  plugins.nvim_scrollbar, -- right side scrollbar that shows lsp diagnostics and looks good with tokyonight
  plugins.nvim_treesitter_endwise, -- wisely add "end" in lua, ruby, vimscript, etc.
  plugins.nvim_treesitter_textobjects, -- enable some more text objects for functions, classes, etc. also covers vim-swap functionality. (breaks in markdown! something about a bad treesitter query)
  plugins.nvim_ts_autotag, -- automatically close and rename html tags
  plugins.nvim_yati, -- better treesitter support for python and others
  plugins.org_bullets, -- spiffy bullet icons and todo icons, adapted for use in markdown files
  plugins.persistent_breakpoints, -- persist breakpoints between sessions
  plugins.phpactor_nvim, -- Vim RPC refactoring plugin https://phpactor.readthedocs.io/en/master/vim-plugin/man.html
  plugins.range_highlight_nvim, -- live preview cmd ranges e.g. :1,2
  plugins.refactoring_nvim, -- refactoring plugin with telescope support
  plugins.splitjoin_vim, -- split and join php arrays to/from multiline/single line (gS, gJ) SO USEFUL! (see also: AckslD/nvim-trevJ.lua) TODO: replace with https://github.com/CKolkey/ts-node-action
  plugins.surround_ui_nvim, -- which-key mappings for nvim-surround
  plugins.symbols_outline_nvim, -- alternative to aerial and vista.vim - show file symbols in sidebar
  plugins.tabout_nvim, -- tab to move out of parens, brackets, etc. Trying this out. You have to <c-e> from completion first. (I just don't use it.)
  plugins.telescope_dap_nvim, -- helpful dap stuff like variables and breakpoints
  plugins.todo_comments_nvim, -- prettier todo, etc. comments, sign column indicators, and shortcuts to find them all in lsp-trouble or telescope
  plugins.typescript_nvim, -- advanced typescript lsp and null_ls features
  plugins.undotree, -- show a sidebar with branching undo history so you can redo on a different branch of changes TODO: replace with https://github.com/debugloop/telescope-undo.nvim ?
  plugins.vim_abolish, -- No lazy load. I tried others but this is the only stable one so far (for :S)
  plugins.vim_fugitive, -- git and github integration. I really only need this for GBrowse, Git blame, y<C-g> etc.
  plugins.vim_git, -- Git file mappings and functions (e.g. rebase helpers like R, P, K) and syntax highlighting, etc. I add mappings in my plugin config.
  plugins.vim_jdaddy, --`gqaj` to pretty-print json, `gwaj` to merge the json object in the clipboard with the one under the cursor TODO: remove once I can replace with python -m json.tool from null-ls or whatever
  plugins.vim_lion, -- align on operators like => like easy-align but works better `viiga=` TODO: replace with https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
  plugins.vim_matchup, -- better %
  plugins.vim_projectionist, -- link tests and classes together, etc. works with per-project .projections.json TODO: replace with https://github.com/gbprod/open-related.nvim or https://github.com/otavioschwanck/telescope-alternate.nvim or https://github.com/rgroli/other.nvim
  plugins.vim_startify, -- I really don't like alpha-nvim. It's handy to have the startify utf-8 box function. And I make use of the startify session segment and commands to have named per-project sessions.
  plugins.vim_unimpaired, -- lots of useful, basic keyboard shortcuts
  plugins.zk_nvim, -- Zettelkasen notes tool
  { 'LinArcX/telescope-env.nvim', event = 'VimEnter', dependencies = 'nvim-telescope/telescope.nvim', config = function() require 'telescope'.load_extension 'env' end }, -- telescope source for env vars
  { 'aklt/plantuml-syntax', event = 'VimEnter' }, -- plantuml filetype
  { 'antosha417/nvim-lsp-file-operations', dependencies = { 'nvim-lua/plenary.nvim', 'kyazdani42/nvim-tree.lua' } }, -- enable lsp file-based code actions
  { 'axelvc/template-string.nvim', ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } }, -- tiny plugin to convert literal strings to dynamic strings
  { 'ethanholz/nvim-lastplace', event = 'BufRead', opts = {} }, -- open files where you left off. Works!
  { 'felipec/vim-sanegx', keys = 'gx' }, -- open url with gx
  { 'fourjay/vim-hurl', event = 'VimEnter' }, -- hurl filetype and fold expression
  { 'fpob/nette.vim', event = 'VimEnter' }, -- syntax file for .neon format (not in polyglot as of 2021-03-26)
  { 'gbprod/php-enhanced-treesitter.nvim', branch = 'main', ft = 'php' }, -- sql and regex included
  { 'gpanders/editorconfig.nvim' }, -- standard config for basic editor settings (no lazy load) (apparently no longer needed with neovim 0.9?? https://github.com/neovim/neovim/pull/21633 )
  { 'iamcco/markdown-preview.nvim', ft = 'markdown', build = function() vim.fn['mkdp#util#install']() end }, -- :MarkdownPreview
  { 'itchyny/vim-highlighturl', event = 'BufRead' }, -- just visually highlight urls like in a browser
  { 'jghauser/mkdir.nvim', event = 'BufRead', config = function() require 'mkdir' end }, -- automatically create missing directories on save
  { 'kylechui/nvim-surround', event = 'BufRead', opts = {} }, -- alternative to vim-surround and vim-sandwich
  { 'lewis6991/foldsigns.nvim', event = 'BufRead', opts = {} }, -- show the most important sign hidden by a fold in the fold sign column
  { 'luukvbaal/stabilize.nvim', event = 'BufRead', opts = {} }, -- when opening trouble or splits or quickfix or whatever, don't move the starting window.
  { 'martinda/Jenkinsfile-vim-syntax', event = 'VimEnter' }, -- Jenkinsfile syntax highlighting
  { 'michaeljsmith/vim-indent-object', event = 'BufRead' }, -- select in indentation level e.g. vii. I use this very frequently. TODO: replace with https://github.com/kiyoon/treesitter-indent-object.nvim (replaced with chrisgrieser/nvim-various-textobjs)
  { 'nvim-zh/colorful-winsep.nvim', event = 'BufRead' }, -- just a clearer separator between windows (I don't need this)
  { 'rhysd/committia.vim', ft = 'gitcommit' }, -- prettier commit editor when git brings up the commit editor in vim. Really cool!
  { 'sickill/vim-pasta', event = 'BufRead' }, -- always paste with context-sensitive indenting. Tried this one, had lots of problems: https://github.com/hrsh7th/nvim-pasta
  { 'tpope/vim-apathy', ft = { 'lua', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'python' } }, -- tweak built-in vim features to allow jumping to javascript (and others like lua) module location with gf TODO: breaking with javascriptreact
  { 'tpope/vim-cucumber', event = 'VimEnter' }, -- gherkin filetype syntax highlighting (erroring out)
  { 'tpope/vim-eunuch', cmd = { 'Mkdir', 'Remove', 'Rename' } }, -- directory shortcuts TODO: replace with https://github.com/chrisgrieser/nvim-ghengis
}
-- }}}
