local mason_path = vim.fn.stdpath('data') .. '/mason'

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

return {
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
