return {
  "folke/tokyonight.nvim",
  opts = {
    style = "night",
    lualine_bold = true, -- bold headers for each section header
    day_brightness = 0.15, -- high contrast but colorful
    on_highlights = function(hl, c)
      local util = require("tokyonight.util")

      hl.Folded = {
        -- change the fold color to be more subtle in both night and day modes
        -- yes, the bg was set to an fg color in tokyonight
        bg = util.darken(c.fg_gutter, 0.1),
      }

      hl.ColorColumn = {
        -- higher contrast since I am trying xiyaowong/virtcolumn.nvim
        bg = util.lighten(c.black, 1.05),
      }
    end,
  },
}
