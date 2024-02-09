-- vim: set foldmethod=marker:

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
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('hi_yanked_text', { clear = true }),
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
-- vim.env.PATH = vim.env.HOME .. '/.asdf/installs/nodejs/17.8.0/bin:' .. vim.env.PATH
vim.env.PATH = vim.env.HOME .. '/.asdf/installs/nodejs/20.8.0/bin:' .. vim.env.PATH -- cspell only works on node 18+
-- vim.env.PATH = vim.env.HOME .. '/.asdf/installs/php/8.2.12/bin:' .. vim.env.PATH

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
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { group = 'unusual_filetypes', pattern = '.{env,env.*}', callback = function() vim.bo.filetype = 'sh' end })
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
