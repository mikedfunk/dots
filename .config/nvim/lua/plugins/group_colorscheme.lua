return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
    dependencies = {
      {
        "folke/tokyonight.nvim",
        opts = {
          style = "night",
          lualine_bold = true, -- bold headers for each section header
          day_brightness = 0.15, -- high contrast but colorful

          -- jack up all saturation, default is too dull!
          on_colors = function(colors)
            local hsluv = require("tokyonight.hsluv")
            local multiplier = 1.6

            for k, v in pairs(colors) do
              if type(v) == "string" and v ~= "NONE" then
                local hsv = hsluv.hex_to_hsluv(v)
                hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                colors[k] = hsluv.hsluv_to_hex(hsv)
              elseif type(v) == "table" then
                for kk, vv in pairs(v) do
                  local hsv = hsluv.hex_to_rgb(vv)
                  hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
                  colors[k][kk] = hsluv.rgb_to_hex(hsv)
                end
              end
            end
          end,
        },
      },
    },
  },
}
