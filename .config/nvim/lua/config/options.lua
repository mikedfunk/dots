-- vim: set foldmethod=marker:
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.joinspaces = false -- Prevents inserting two spaces after punctuation on a join (J)
vim.o.swapfile = true -- I hate them but they help if neovim crashes

-- https://github.com/luukvbaal/stabilize.nvim
vim.o.splitkeep = "screen"

vim.o.spellfile = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add") -- this is necessary because nvim-treesitter is first in the runtimepath
vim.o.spelloptions = table.concat({
  "noplainbuffer",
  "camel",
}, ",")
-- vim.o.foldlevel = 99 -- default high foldlevel so files are not folded on read
vim.o.formatoptions = "croqjt"
vim.o.timeoutlen = 250 -- trying this out for which-key.nvim
-- vim.o.textwidth = 80 -- line width to break on with <visual>gw TODO: getting overridden to 999 somewhere
vim.o.relativenumber = true -- relative line numbers
vim.o.mousemoveevent = true -- enable hover X on bufferline tabs

-- turn off relativenumber in insert mode and others {{{
local norelative_events = { "InsertEnter", "WinLeave", "FocusLost" }
local relative_events = { "InsertLeave", "WinEnter", "FocusGained", "BufNewFile", "BufReadPost" }
vim.api.nvim_create_augroup("relnumber_toggle", { clear = true })
vim.api.nvim_create_autocmd(relative_events, {
  group = "relnumber_toggle",
  callback = function()
    if vim.o.number then
      vim.o.relativenumber = true
    end
  end,
  desc = "turn on relative number",
})
vim.api.nvim_create_autocmd(norelative_events, {
  group = "relnumber_toggle",
  callback = function()
    if vim.o.number then
      vim.o.relativenumber = false
    end
  end,
  desc = "turn off relative number",
})
-- }}}

vim.o.fillchars = table.concat({
  "eob: ", -- remote tildes in startify
  "diff:/", -- for removed blocks, set bg to diagonal lines
  "fold: ",
}, ",")

-- ripped from here https://github.com/tamton-aquib/essentials.nvim/blob/main/lua/essentials.lua
---@return string: foldtext
_G.simple_fold = function()
  local fs, fe = vim.v.foldstart, vim.v.foldend
  local start_line = vim.fn.getline(fs):gsub("\t", ("\t"):rep(vim.opt.ts:get())) ---@diagnostic disable-line undefined-field
  local end_line = vim.trim(vim.fn.getline(fe)) ---@diagnostic disable-line param-type-mismatch
  local spaces = (" "):rep(vim.o.columns - start_line:len() - end_line:len() - 7)

  -- return start_line .. '  ' .. end_line .. spaces
  return start_line .. " … " .. end_line .. spaces
end
vim.opt.foldtext = "v:lua.simple_fold()"

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("hi_yanked_text", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
  desc = "highlight yanked text",
})

vim.opt.cmdheight = 0 -- height of the bottom line that shows command output. I don't like lvim's default of 2.
vim.opt.showtabline = 1 -- show tabs only when more than one file
vim.o.inccommand = "split" -- preview substitute in neovim `:h inccommand`
vim.o.foldcolumn = "auto" -- make folds visible left of the sign column. Very cool ui feature!
-- vim.o.lazyredraw = true -- to speed up rendering and avoid scrolling problems (noice doesn't like this)
-- vim.o.hlsearch = false -- disable auto highlight all search results, this is handled by highlight-current-n
vim.o.pumblend = 15 -- popup pseudo-transparency
vim.o.winblend = 15 -- floating window pseudo-transparency
vim.o.exrc = true -- TODO: not working
vim.o.secure = true
-- vim.o.smartindent = true -- Do smart autoindenting when starting a new line. Absolute must.
-- vim.o.autoindent = true
vim.o.laststatus = 3 -- new neovim global statusline
if vim.fn.filereadable("/usr/share/dict/words") == 1 then
  vim.opt.dictionary:append("/usr/share/dict/words")
end -- :h dictionary
-- vim.o.updatetime = 650 -- wait time before CursorHold activation
vim.o.updatetime = 100 -- wait time before CursorHold activation

vim.cmd("packadd! cfilter")

-- vim-cool replacement https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/iyvcdf0/
vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end, vim.api.nvim_create_namespace("auto_hlsearch"))

-- avoids lag when scrolling
-- https://github.com/vimpostor/vim-tpipeline#how-do-i-update-the-statusline-on-every-cursor-movement
-- vim.cmd 'set guicursor='

if vim.fn.executable("ag") == 1 then
  vim.o.grepprg = "ag --vimgrep"
  vim.o.grepformat = "%f:%l:%c%m"
elseif vim.fn.executable("git") == 1 then
  vim.o.grepprg = "git grep"
  vim.o.grepformat = "%f:%l:%m,%m %f match%ts,%f"
end

vim.cmd("cabbr <expr> %% expand('%:p:h')") -- in ex mode %% is current dir
vim.o.sessionoptions = table.concat({
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "globals",
}, ",")

-- bug: I don't see a way to apply _local_ iabbrevs so if you load a
-- markdown file it will enable the abbrev in the entire workspace :/

-- show vert lines at the psr-2 suggested column limits
vim.o.colorcolumn = table.concat({
  80,
  120,
}, ",")

-- prettier hidden chars. turn on with :set list or yol (different symbols)
vim.o.listchars = table.concat({
  "nbsp:␣",
  "tab:▸•",
  "eol:↲",
  "trail:•",
  "extends:»",
  "precedes:«",
  "trail:•",
}, ",")
vim.opt.list = false

vim.cmd("highlight! Comment cterm=italic, gui=italic") -- italic comments https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic
vim.cmd("highlight! Special cterm=italic, gui=italic")

-- vim.lsp.set_log_level("debug") -- enable lsp debug logging - you can open the log with :lua vim.cmd('e'..vim.lsp.get_log_path()) or tail -f ~/.local/state/nvim/lsp.log

-- https://www.reddit.com/r/neovim/comments/opipij/guide_tips_and_tricks_to_reduce_startup_and/
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  -- 'spellfile_plugin'
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- use latest node and php version
-- vim.env.PATH = vim.env.HOME .. '/.asdf/installs/nodejs/17.8.0/bin:' .. vim.env.PATH
vim.env.PATH = vim.env.HOME .. "/.asdf/installs/nodejs/20.8.0/bin:" .. vim.env.PATH -- cspell only works on node 18+
-- vim.env.PATH = vim.env.HOME .. '/.asdf/installs/php/8.2.12/bin:' .. vim.env.PATH

-- vim-markdown (builtin) {{{
-- https://github.com/tpope/vim-markdown
vim.g["markdown_fold_style"] = "nested"
vim.g["markdown_folding"] = 1
-- vim.g['markdown_syntax_conceal'] = 0
vim.g["markdown_minlines"] = 100

-- https://old.reddit.com/r/vim/comments/2x5yav/markdown_with_fenced_code_blocks_is_great/
vim.g["markdown_fenced_languages"] = {
  "css",
  "html",
  "javascript=javascript.jsx",
  "js=javascript.jsx",
  "json=javascript",
  "lua",
  "php",
  "python",
  "ruby",
  "scss",
  "sh",
  "sql",
  "typescript",
  "typescriptreact",
  "xml",
}
-- }}}

-- lsp config {{{
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

vim.diagnostic.config({
  float = { border = "rounded" },
})
-- }}}

vim.filetype.add({ pattern = { ["compose%.yml"] = "yaml.docker-compose" } })
vim.filetype.add({ pattern = { ["docker-compose%.yml"] = "yaml.docker-compose" } })
vim.filetype.add({ pattern = { ["%.babelrc"] = "json" } })
vim.filetype.add({ pattern = { ["Dockerfile-.*"] = "dockerfile" } })
vim.filetype.add({ pattern = { ["Dockerfile%..*"] = "dockerfile" } })
vim.filetype.add({ pattern = { [".env"] = "sh" } })
vim.filetype.add({ pattern = { [".env.example"] = "sh" } })
