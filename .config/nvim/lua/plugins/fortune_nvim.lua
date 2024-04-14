return {
  {
    "mikedfunk/fortune.nvim",
    config = true,
    dependencies = { "nvimdev/dashboard-nvim" },
  },
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        footer = function()
            return require("fortune").get_fortune()
        end
      }
    }
  }
}
