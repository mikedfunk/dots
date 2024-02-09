return {
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
