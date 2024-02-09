-- persistent-breakpoints {{{
return {
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
