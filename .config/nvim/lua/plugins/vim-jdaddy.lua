return {
  "tpope/vim-jdaddy",
  event = "BufRead",
  dependencies = "folke/which-key.nvim",
  config = function()
    require("which-key").register({
      q = { name = "Format JSON", a = { name = "Format JSON", j = { name = "Format JSON" } } },
      w = { name = "Format JSON", a = { name = "Format JSON", j = { name = "Format JSON outer" } } },
    }, { prefix = "g" })
  end,
}
