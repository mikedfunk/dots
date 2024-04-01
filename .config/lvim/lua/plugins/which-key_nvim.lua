-- TODO: rewrite without lvim global object
-- lvim.builtin.which_key.opts.nowait = false
-- lvim.builtin.which_key.vopts.nowait = false
lvim.builtin.which_key.setup.icons.group = ' '
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

lvim.builtin.which_key.mappings[';'] = nil

lvim.builtin.which_key.on_config_done = function()
  -- Comment.nvim
  require 'which-key'.register({
    b = { name = 'Comment', c = { 'Toggle blockwise comment' } },
    c = { name = 'Comment', c = { 'Toggle linewise comment' } },
  }, { prefix = 'g' })

  require 'which-key'.register({ bp = { 'Pin/Unpin' } })
  require 'which-key'.register({ bo = { 'Delete All but Pinned' } })
  require 'which-key'.register({ b = { 'Next Buffer' } }, { prefix = ']' })
  require 'which-key'.register({ b = { 'Previous Buffer' } }, { prefix = '[' })
  require 'which-key'.register({ B = { 'Move to Next Buffer' } }, { prefix = ']' })
  require 'which-key'.register({ B = { 'Move to Previous Buffer' } }, { prefix = '[' })

  require 'which-key'.register({ dv = { 'Eval Visual' } })
  require 'which-key'.register({ ds = { 'Start' } })
  require 'which-key'.register({ dd = { 'Disconnect' } })
  require 'which-key'.register({ de = { 'Expression Breakpoint' } })
  require 'which-key'.register({ dL = { 'Log on Line' } })
  require 'which-key'.register({ dh = { 'Eval Hover' } })
  require 'which-key'.register({ dq = { 'Quit' } })

  require 'which-key'.register({ e = { 'Explore File' } })

  require 'which-key'.register({ LC = { 'Nvim-Cmp Status' } })

  require 'which-key'.register({ gL = { 'Git File Log' } })

  require 'which-key'.register({ lc = { 'Configure LSP' } })
  require 'which-key'.register({ lR = { 'Restart LSP' } })
  require 'which-key'.register({ lT = { 'Toggle Diagnostics' } })
  require 'which-key'.register({ lf = { 'Format' } })
  require 'which-key'.register({ lf = { 'Format' } }, { mode = 'v' })
  require 'which-key'.register({ lC = { 'Toggle Contextive' } })
  require 'which-key'.register({ la = { 'Code Action' } })
  require 'which-key'.register({ la = { 'Code Action' } }, { mode = 'v' })
  require 'which-key'.register({ l = { 'LSP' } }, { mode = 'v' })

  require 'which-key'.register({ Dl = { 'Use other branch' } }, { mode = 'v' })
  require 'which-key'.register({ Dr = { 'Use current branch' } }, { mode = 'v' })
  require 'which-key'.register({ Du = { 'Update diff' } })

  require 'which-key'.register({ br = { 'Recent' } })
  require 'which-key'.register({ bd = { 'Delete' } })
  require 'which-key'.register({ bf = { 'Find' } })
  require 'which-key'.register({ bp = { 'Pin/Unpin' } })
  require 'which-key'.register({ bo = { 'Delete All but Pinned' } })

  require 'which-key'.register({ m = { 'Make' } })
  require 'which-key'.register({ D = { 'DiffGet' } })
end

return {}
