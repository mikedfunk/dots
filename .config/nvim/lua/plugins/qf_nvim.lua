return {
  "ten3roberts/qf.nvim",
  commands = { "copen", "cclose" },
  keys = {
    {
      "<C-q>",
      function()
        require("qf").toggle("c", true)
      end,
      desc = "Toggle Quickfix",
    },
  },
  opts = {},
}
