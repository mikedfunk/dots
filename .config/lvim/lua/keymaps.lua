-- vim: set foldmethod=marker:

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
vim.keymap.set('n', '<C-w>t', 'mz:tabe %<cr>`z', { noremap = true, desc = 'Open in new tab' })
vim.keymap.set('n', '<C-l>', ':silent! call LocListToggle()<CR>', { noremap = true, desc = 'Toggle Location List' })

vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeFindFileToggle<CR>', { noremap = true, desc = 'Explore File' })
-- lvim.builtin.which_key.mappings['e'] = { 'Expore File' }
vim.keymap.set('n', '<leader>m', '<Cmd>silent make<CR>', { noremap = true, desc = 'Make' })
-- vim.keymap.set('n', '<leader>E', '<Cmd>NvimTreeToggle<CR>', { noremap = true, desc = 'Expore' })
-- lvim.builtin.which_key.mappings['E'] = { 'Explore' }

vim.keymap.set('n', '<leader>lc', '<Cmd>LspSettings buffer<CR>', { noremap = true, desc = 'Configure LSP' })
vim.keymap.set('n', '<leader>lR', '<Cmd>LspRestart<CR>', { noremap = true, desc = 'Restart LSP' })

vim.keymap.set('n', '<leader>bd', '<Cmd>bd<CR>', { noremap = true, desc = 'Delete' })
-- vim.keymap.set('n', '<leader>bf', '<Cmd>Telescope buffers initial_mode=insert sort_mru=true<CR>', { noremap = true, desc = 'Find' })
lvim.builtin.which_key.mappings.b.f = { '<Cmd>Telescope buffers initial_mode=insert sort_mru=true<CR>', 'Find' }
vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { noremap = true, desc = 'Pin/Unpin' })
vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineGroupClose ungrouped<CR>', { noremap = true, desc = 'Delete All but Pinned' })

-- lvim.lsp.buffer_mappings.normal_mode['gt'] = { '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Goto type definition' }
-- lvim.lsp.buffer_mappings.normal_mode['go'] = { '<Cmd>lua vim.lsp.buf.incoming_calls()<CR>', 'Incoming calls' }
-- lvim.lsp.buffer_mappings.normal_mode['gO'] = { '<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>', 'Outgoing calls' }

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    -- telescope versions of some lsp mappings
    vim.keymap.set('n', '<leader>gr', '<Cmd>Telescope lsp_references<CR>', { noremap = true, buffer = bufnr, desc = 'Telescope References' })
    require 'which-key'.register({ gr = { 'Telescope References' } })
    vim.keymap.set('n', '<leader>gd', '<Cmd>Telescope lsp_definitions<CR>', { noremap = true, buffer = bufnr, desc = 'Goto Definition' })
    require 'which-key'.register({ gd = { 'Go to Definition' } })
    vim.keymap.set('n', '<leader>gI', '<Cmd>Telescope lsp_implementations<CR>', { noremap = true, buffer = bufnr, desc = 'Go to Implementation' })
    require 'which-key'.register({ gI = { 'Go to Implementation' } })
    vim.keymap.set('n', '<leader>gt', '<Cmd>Telescope lsp_type_definitions<CR>', { noremap = true, buffer = bufnr, desc = 'Go to Type Definition' })
    require 'which-key'.register({ gt = { 'Go to Type Definition' } })
    vim.keymap.set('n', '<leader>go', '<Cmd>Telescope lsp_incoming_calls<CR>', { noremap = true, buffer = bufnr, desc = 'Incoming Calls' })
    require 'which-key'.register({ go = { 'Incoming Calls' } })
    vim.keymap.set('n', '<leader>gO', '<Cmd>Telescope lsp_outgoing_calls<CR>', { noremap = true, buffer = bufnr, desc = 'Outgoing Calls' })
    require 'which-key'.register({ gO = { 'Outgoing Calls' } })
    -- vim.keymap.set('n', '<leader>lD', '<Cmd>Telescope diagnostics bufnr=0 theme=dropdown<CR>', { noremap = true, buffer = bufnr, desc = 'Buffer Diagnostics' })
    vim.keymap.set('i', '<c-v>', function() vim.lsp.buf.signature_help() end, { buffer = bufnr, noremap = true })
    vim.keymap.set('i', '<c-k>', function() vim.lsp.buf.signature_help() end, { buffer = bufnr, noremap = true })
    vim.keymap.set('n', '<leader>lh', function() vim.diagnostic.open_float() end, { noremap = true, buffer = bufnr, desc = 'Line Diagnostic Hover' })
    require 'which-key'.register({ lh = { 'Line Diagnostic Hover' } })
  end,
})

-- debugger mappings
vim.keymap.set('v', '<leader>dv', function() require 'dapui'.eval() end, { noremap = true, desc = 'Eval Visual' })

vim.keymap.set('n', '<leader>ds', function() require 'dap'.continue() end, { noremap = true, desc = 'Start' })
vim.keymap.set('n', '<leader>dd', function() require 'dap'.disconnect() end, { noremap = true, desc = 'Disconnect' })

vim.keymap.set('n', '<leader>de', function()
  vim.ui.input(
    { prompt = 'Breakpoint condition: ' },
    function(input) require 'dap'.set_breakpoint(input) end
  )
end, { noremap = true, desc = 'Expression Breakpoint' })

vim.keymap.set('n', '<leader>dL', function()
  vim.ui.input(
    { prompt = 'Log point message: ' },
    function(input) require 'dap'.set_breakpoint(nil, nil, input) end
  )
end, { noremap = true, desc = 'Log on Line' })

vim.keymap.set('n', '<leader>dh', function() require 'dapui'.eval() end, { noremap = true, desc = 'Eval Hover' })
vim.keymap.set('n', '<leader>dq', function() require('dap').terminate() end, { noremap = true, desc = 'Quit' })

vim.keymap.set('n', '<leader>LC', '<Cmd>CmpStatus<CR>', { noremap = true, desc = 'Nvim-Cmp Status' })

-- lvim.builtin.which_key.mappings['h'] = nil -- I map this in hop.nvim

-- lvim.builtin.which_key.mappings["g"]['g'].name = 'Tig'
vim.keymap.set('n', '<leader>gL', '<Cmd>0Gclog<CR>', { noremap = true, desc = 'Git File Log' })

local are_diagnostics_visible = true
local toggle_diagnostics = function()
  are_diagnostics_visible = not are_diagnostics_visible
  if are_diagnostics_visible then vim.diagnostic.disable() else vim.diagnostic.enable() end
end
vim.keymap.set('n', '<leader>lT', toggle_diagnostics, { noremap = true, desc = 'Toggle Diagnostics' })

vim.keymap.set('n', '<leader>lf', function() require 'lvim.lsp.utils'.format { timeout_ms = 30000 } end, { noremap = true, desc = 'Format' })
vim.keymap.set('v', '<leader>lf', function() require 'lvim.lsp.utils'.format { timeout_ms = 30000 } end, { noremap = true, desc = 'Format' })

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

vim.keymap.set('n', '<leader>lC', toggle_contextive, { noremap = true, desc = 'Toggle Contextive' })
-- }}}

-- put cursor at end of text on y and p
vim.keymap.set('v', 'y', 'y`]', { noremap = true, desc = 'Cursor at end' })
vim.keymap.set('v', 'p', 'p`]', { noremap = true, desc = 'Cursor at end' })
vim.keymap.set('n', 'p', 'p`]', { noremap = true, desc = 'Cursor at end' })

-- disable alt esc
lvim.keys.insert_mode['jk'] = nil
lvim.keys.insert_mode['kj'] = nil
lvim.keys.insert_mode['jj'] = nil

-- Wrapped lines goes down/up to next row, rather than next line in file.
vim.keymap.set('n', 'j', "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
vim.keymap.set('n', 'k', "v:count ? 'k' : 'gk'", { noremap = true, expr = true })

-- Easier horizontal scrolling
vim.keymap.set('n', 'zl', 'zL', { noremap = true, desc = 'Scroll Right' })
vim.keymap.set('n', 'zh', 'zH', { noremap = true, desc = 'Scroll Left' })

-- stupid f1 help
lvim.keys.normal_mode['<f1>'] = '<nop>'
lvim.keys.insert_mode['<f1>'] = '<nop>'

vim.keymap.set('n', '<leader>la', function() vim.lsp.buf.code_action() end, { noremap = true, desc = 'Code Action' })
vim.keymap.set('v', '<leader>la', function() vim.lsp.buf.code_action() end, { noremap = true, desc = 'Code Action' })

-- diffget for mergetool {{{
-- (no longer) disabled in favor of akinsho/git-conflict.nvim
vim.keymap.set('v', '<leader>Dl', '<Cmd>diffget LOC<CR>', { noremap = true, desc = 'Use other branch' })
vim.keymap.set('v', '<leader>Dr', '<Cmd>diffget REM<CR>', { noremap = true, desc = 'Use current branch' })

vim.keymap.set('n', '<leader>Du', '<Cmd>diffupdate<CR>', { noremap = true, desc = 'Update diff' })
-- }}}

vim.keymap.set('n', '<leader>br', '<Cmd>Telescope oldfiles<CR>', { noremap = true, desc = 'Recent' })

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

vim.keymap.set('n', '<leader>bi', ':call DeleteInactiveBufs()<CR>', { noremap = true, desc = 'Delete Inactive Buffers' })
-- }}}

vim.keymap.set('n', ']b', '<Cmd>BufferLineCycleNext<CR>', { noremap = true, desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<Cmd>BufferLineCyclePrev<CR>', { noremap = true, desc = 'Previous Buffer' })
vim.keymap.set('n', ']B', '<Cmd>BufferLineMoveNext<CR>', { noremap = false, desc = 'Move to Next Buffer' })
vim.keymap.set('n', '[B', '<Cmd>BufferLineMovePrev<CR>', { noremap = false, desc = 'Move to Previous Buffer' })
-- see ../plugins/which-key_nvim.lua for which-key hints, but not mappings
