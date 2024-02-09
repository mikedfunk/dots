 -- find font characters, symbols, nerd font icons, and emojis
return {
  'ziontee113/icon-picker.nvim',
  dependencies = 'stevearc/dressing.nvim',
  cmd = { 'IconPickerYank', 'IconPickerInsert', 'IconPickerNormal' },
  opts = { disable_legacy_commands = true }
}
