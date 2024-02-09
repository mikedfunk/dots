-- vim: set foldmethod=marker:

local is_installed = require 'helpers'.is_installed

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

-- Fold Textobject Maps: {{{
vim.keymap.set('o', 'iz', '<Cmd>normal! [zj0v]zk$<CR>', { noremap = true })
vim.keymap.set('x', 'iz', '<Cmd>normal! [zj0o]zk$<CR>', { noremap = true })
vim.keymap.set('o', 'az', '<Cmd>normal! [zv]z$<CR>', { noremap = true })
vim.keymap.set('x', 'az', '<Cmd>normal! [zo]z$<CR>', { noremap = true })
-- }}}

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

  vim.api.nvim_create_autocmd('CursorHold', {
    group = vim.api.nvim_create_augroup('lsp_hover_def', { clear = true }),
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
