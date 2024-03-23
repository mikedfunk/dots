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

return {}
