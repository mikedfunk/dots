-- TODO: rewrite without lvim global object
lvim.builtin.bufferline.active = true -- bufferline.nvim
vim.cmd [[hi! default link PanelHeading BufferLineTabSelected]]
vim.api.nvim_create_augroup('bufferline_fill_fix', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'bufferline_fill_fix',
  callback = function() vim.cmd [[silent! hi! link BufferLineFill BufferLineGroupSeparator]] end,
})

-- -- Bufferline tries to make everything italic. Why?
-- moved to no_italic below
-- lvim.builtin.bufferline.highlights.background = { italic = false }
-- lvim.builtin.bufferline.highlights.buffer_selected.italic = false
-- lvim.builtin.bufferline.highlights.diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.hint_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.hint_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.info_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.info_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.warning_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.warning_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.error_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.error_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate_visible = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate = { italic = false }
-- lvim.builtin.bufferline.highlights.pick_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.pick_visible = { italic = false }
-- lvim.builtin.bufferline.highlights.pick = { italic = false }

lvim.builtin.bufferline.options.persist_buffer_sort = true
lvim.builtin.bufferline.options.hover.enabled = true
lvim.builtin.bufferline.options.sort_by = 'insert_after_current'
lvim.builtin.bufferline.options.always_show_bufferline = true
lvim.builtin.bufferline.options.separator_style = 'slant'
-- lvim.builtin.bufferline.options.numbers = 'ordinal'

-- remove all sidebar headers
for k, _ in ipairs(lvim.builtin.bufferline.options.offsets) do
  lvim.builtin.bufferline.options.offsets[k].text = nil
end

local is_bufferline_installed, _ = pcall(require, 'bufferline')
if is_bufferline_installed then
  lvim.builtin.bufferline.options.groups = lvim.builtin.bufferline.options.groups or {}
  lvim.builtin.bufferline.options.groups.items = lvim.builtin.bufferline.options.groups.items or {}
  table.insert(
    lvim.builtin.bufferline.options.groups.items,
    require 'bufferline.groups'.builtin.pinned:with { icon = "" }
  )

  lvim.builtin.bufferline.options.style_preset = require 'bufferline'.style_preset.no_italic
end

return {}
