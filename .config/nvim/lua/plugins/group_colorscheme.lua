return {
  -- {
  --   "LazyVim/LazyVim",
  --   dependencies = {
  --     { "sainnhe/everforest" },
  --   },
  --   opts = {
  --     colorscheme = "everforest",
  --   },
  -- },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    opts = {
      style = "night",
      lualine_bold = true, -- bold headers for each section header
      day_brightness = 0.15, -- high contrast but colorful

      -- jack up all saturation, default is too dull!
      on_colors = function(colors)
        local hsluv = require("tokyonight.hsluv")

        -- cyber:
        local hue_shift = 1 -- +: purple, -: green
        -- local hue_shift = 0.95 -- +: purple, -: green
        -- local hue_shift = 1.05 -- +: purple, -: green
        local saturation_multiplier = 2.50

        -- forest:
        -- local saturation_multiplier = 0.7
        -- local hue_shift = 0.5 -- +: purple, -: green

        for k, v in pairs(colors) do
          if type(v) == "string" and v ~= "NONE" then
            local hsv = hsluv.hex_to_hsluv(v)
            hsv[1] = hsv[1] * hue_shift > 360 and hsv[1] * hue_shift - 360 or hsv[1] * hue_shift
            hsv[2] = hsv[2] * saturation_multiplier > 100 and 100 or hsv[2] * saturation_multiplier
            colors[k] = hsluv.hsluv_to_hex(hsv)
          elseif type(v) == "table" then
            if vim.islist(v) then
              for kk, vv in ipairs(v) do
                if type(vv) == "string" and vv ~= "NONE" then
                  local hsv = hsluv.hex_to_hsluv(vv)
                  hsv[1] = hsv[1] * hue_shift > 360 and hsv[1] * hue_shift - 360 or hsv[1] * hue_shift
                  hsv[2] = hsv[2] * saturation_multiplier > 100 and 100 or hsv[2] * saturation_multiplier
                  colors[k][kk] = hsluv.hsluv_to_hex(hsv)
                end
              end
            else
              for kk, vv in pairs(v) do
                if type(vv) == "string" and vv ~= "NONE" then
                  local hsv = hsluv.hex_to_hsluv(vv)
                  hsv[1] = hsv[1] * hue_shift > 360 and hsv[1] * hue_shift - 360 or hsv[1] * hue_shift
                  hsv[2] = hsv[2] * saturation_multiplier > 100 and 100 or hsv[2] * saturation_multiplier
                  colors[k][kk] = hsluv.hsluv_to_hex(hsv)
                end
              end
            end
          end
        end
      end,
      on_highlights = function(highlight, colors)
        local util = require("tokyonight.util")
        highlight.Folded = {
          fg = colors.blue,
          bg = util.darken(colors.fg_gutter, 0.3), -- make it darker in dark mode, lighter in light mode
        }
      end,
    },
  },
  {
    "jpwol/thorn.nvim",
    enabled = false,
    lazy = false,
    dependencies = {
      {
        "LazyVim/LazyVim",
        opts = {
          colorscheme = "thorn",
        },
      },
    },
    priority = 1000,
    opts = {},
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    dependencies = {
      {
        "LazyVim/LazyVim",
        opts = {
          colorscheme = "everforest",
        },
      },
    },
    priority = 1000,
  },
  { "rubiin/highlighturl.nvim", event = "VeryLazy", opts = {} },
}
