return {
  "L3MON4D3/LuaSnip",
  keys = {
    {
      "<a-l>", -- complete without blink.nvim
      function()
        if require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        end
      end,
      desc = "Expand snippet or jump forward",
      mode = { "i", "s" },
    },
    {
      "<a-c>", -- pneumonic: choice
      function()
        if require("luasnip").choice_active() then
          require("luasnip").change_choice(1)
        end
      end,
      desc = "Next choice",
      mode = { "i", "s" },
    },
  },
  opts = function()
    require("luasnip.loaders.from_lua").lazy_load()
  end,
}
