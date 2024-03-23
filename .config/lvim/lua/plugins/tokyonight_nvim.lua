-- TODO: rewrite without lvim global object
lvim.colorscheme = 'tokyonight'
lvim.builtin.lualine.options.theme = 'tokyonight'
lvim.builtin.theme.name = 'tokyonight'
-- lvim.builtin.theme.tokyonight.options.style = 'storm'
-- lvim.builtin.theme.tokyonight.options.style = 'moon'
lvim.builtin.theme.tokyonight.options.style = 'night'

lvim.builtin.theme.tokyonight.options.dim_inactive = true -- dim inactive windows
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- bold headers for each section header
lvim.builtin.theme.tokyonight.options.sidebars = { 'NvimTree', 'aerial', 'Outline', 'DapSidebar', 'UltestSummary', 'dap-repl' }
-- lvim.builtin.theme.tokyonight.options.day_brightness = 0.05 -- high contrast
lvim.builtin.theme.tokyonight.options.day_brightness = 0.15 -- high contrast but colorful
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- section headers in lualine theme will be bold
lvim.builtin.theme.tokyonight.options.hide_inactive_statusline = true
-- vim.cmd 'silent! hi! link TabLineFill BufferLineGroupSeparator' -- temp workaround to bufferline background issue

lvim.builtin.theme.tokyonight.options.on_highlights = function(hl, c)
  local util = require 'tokyonight.util'
  hl.Folded = {
    -- change the fold color to be more subtle in both night and day modes
    -- yes, the bg was set to an fg color in tokyonight
    bg = util.darken(c.fg_gutter, 0.1),
  }
  hl.ColorColumn = {
    -- higher contrast since I am trying xiyaowong/virtcolumn.nvim
    bg = util.lighten(c.black, 1.05),
  }
end

return {}
