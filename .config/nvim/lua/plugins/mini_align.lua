return {
  "echasnovski/mini.align",
  event = "BufRead",
  version = false,
  dependencies = "folke/which-key.nvim",
  config = function()
    require("which-key").register({ a = "Align operator right" }, { prefix = "g" })
  end,
}
