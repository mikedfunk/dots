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

return {
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
