return {
  "anuvyklack/fold-preview.nvim",
  dependencies = "anuvyklack/keymap-amend.nvim",
  event = "BufRead",
  -- ft = { 'lua', 'gitconfig', 'dosini' },
  opts = {
    auto = 400,
    border = "rounded",
    -- default_keybindings = false,
  },
}
