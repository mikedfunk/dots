-- TODO: rewrite without lvim global object
return {
  'simrat39/symbols-outline.nvim',
  event = 'BufRead',
  dependencies = 'folke/which-key.nvim',
  init = function()
    vim.keymap.set('n', '<leader>lo', '<Cmd>SymbolsOutline<CR>', { noremap = true, desc = 'Symbols Outline' })
    local heading_options = {
      filetype = 'Outline',
      highlight = 'PanelHeading',
      padding = 1,
      text = 'Symbols'
    }
    if vim.tbl_contains(lvim.builtin.bufferline.options.offsets, heading_options) then return end
    table.insert(lvim.builtin.bufferline.options.offsets, heading_options)

    vim.cmd 'hi link FocusedSymbol TermCursor'
  end,
  opts = {
    width = 35,
    border = 'rounded',
    winblend = vim.o.winblend,
    relative_width = false,
    auto_close = true,
    -- highlight_hovered_item = false,
    -- auto_preview = true,
    autofold_depth = 2,
    auto_unfold_hover = false,
    show_symbol_details = true,
    -- possible values https://github.com/simrat39/symbols-outline.nvim/blob/master/lua/symbols-outline/symbols.lua
    -- symbol_blacklist = {
    --   -- works best for object-oriented code
    --   'Field',
    --   'Function',
    --   'Key',
    --   'Variable',
    -- },
    symbols = {
      Array = { icon = lvim.icons.kind.Array },
      Boolean = { icon = lvim.icons.kind.Boolean },
      Class = { icon = lvim.icons.kind.Class },
      Component = { icon = lvim.icons.kind.Function },
      Constant = { icon = lvim.icons.kind.Constant },
      Constructor = { icon = lvim.icons.kind.Constructor },
      Enum = { icon = lvim.icons.kind.Enum },
      EnumMember = { icon = lvim.icons.kind.EnumMember },
      Event = { icon = lvim.icons.kind.Event },
      Field = { icon = lvim.icons.kind.Field },
      File = { icon = lvim.icons.kind.File },
      Fragment = { icon = lvim.icons.kind.Constant },
      Function = { icon = lvim.icons.kind.Function },
      Interface = { icon = lvim.icons.kind.Interface },
      Key = { icon = lvim.icons.kind.Key },
      Method = { icon = lvim.icons.kind.Method },
      Module = { icon = lvim.icons.kind.Module },
      Namespace = { icon = lvim.icons.kind.Namespace },
      Null = { icon = lvim.icons.kind.Null },
      Number = { icon = lvim.icons.kind.Number },
      Object = { icon = lvim.icons.kind.Object },
      Operator = { icon = lvim.icons.kind.Operator },
      Package = { icon = lvim.icons.kind.Package },
      Property = { icon = lvim.icons.kind.Property },
      String = { icon = lvim.icons.kind.String },
      Struct = { icon = lvim.icons.kind.Struct },
      TypeParameter = { icon = lvim.icons.kind.TypeParameter },
      Variable = { icon = lvim.icons.kind.Variable },
    },
  },
}
