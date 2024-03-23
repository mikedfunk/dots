return {
  'haringsrob/nvim_context_vt',
  event = 'BufRead',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  opts = {
    ---@param node table
    ---@return string
    custom_text_handler = function(node)
      return '↩ ' .. vim.treesitter.get_node_text(node, 0)[1]
    end
  },
}
