return {
  "L3MON4D3/LuaSnip",
  keys = {
    {
      "<a-l>",
      function()
        if require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        end
      end,
      desc = "Expand snippet or jump forward",
      mode = { "i", "s" },
    },
    {
      "<a-h>",
      function()
        if require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        end
      end,
      desc = "Jump backward",
      mode = { "i", "s" },
    },
    {
      "<a-e>",
      function()
        if require("luasnip").choice_active() then
          require("luasnip").change_choice(1)
        end
      end,
      desc = "Next choice",
      mode = { "i", "s" },
    },
  },
}
