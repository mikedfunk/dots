return {
  "akinsho/bufferline.nvim",
  deps = { "folke/which-key.nvim" },
  config = function()
    lvim.builtin.bufferline.active = true -- bufferline.nvim
    vim.cmd [[hi! default link PanelHeading BufferLineTabSelected]]
    vim.api.nvim_create_augroup('bufferline_fill_fix', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = 'bufferline_fill_fix',
      callback = function() vim.cmd [[silent! hi! link BufferLineFill BufferLineGroupSeparator]] end,
    })

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

    -- lunarvim setup {{{
    require("lvim.core.bufferline").setup()
    -- }}}

    lvim.builtin.bufferline.options.groups = lvim.builtin.bufferline.options.groups or {}
    lvim.builtin.bufferline.options.groups.items = lvim.builtin.bufferline.options.groups.items or {}
    table.insert(
      lvim.builtin.bufferline.options.groups.items,
      require 'bufferline.groups'.builtin.pinned:with { icon = "" }
    )

    lvim.builtin.bufferline.options.style_preset = require 'bufferline'.style_preset.no_italic
    vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { noremap = true, desc = 'Pin/Unpin' })
    vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineGroupClose ungrouped<CR>', { noremap = true, desc = 'Delete All but Pinned' })
    vim.keymap.set('n', ']b', '<Cmd>BufferLineCycleNext<CR>', { noremap = true, desc = 'Next Buffer' })
    vim.keymap.set('n', '[b', '<Cmd>BufferLineCyclePrev<CR>', { noremap = true, desc = 'Previous Buffer' })
    vim.keymap.set('n', ']B', '<Cmd>BufferLineMoveNext<CR>', { noremap = false, desc = 'Move to Next Buffer' })
    vim.keymap.set('n', '[B', '<Cmd>BufferLineMovePrev<CR>', { noremap = false, desc = 'Move to Previous Buffer' })
  end,
}
