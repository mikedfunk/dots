return {
  'luukvbaal/statuscol.nvim',
  config = function()
    require 'statuscol'.setup {
      -- relculright = true,
      -- segments = {
      --   { text = { require 'statuscol.builtin'.foldfunc }, click = "v:lua.ScFa" },
      --   {
      --     sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
      --     click = "v:lua.ScSa"
      --   },
      --   { text = { require 'statuscol.builtin'.lnumfunc }, click = "v:lua.ScLa", },
      --   {
      --     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true },
      --     click = "v:lua.ScSa"
      --   },
      -- }
    }
  end
}
