local is_installed = require 'helpers'.is_installed

return {
  'haringsrob/nvim_context_vt',
  event = 'BufRead',
  opts = {
    ---@param node table
    ---@return string|nil
    custom_text_handler = function(node)
      if not is_installed 'nvim-treesitter/nvim-treesitter' then return nil end
      return '↩ ' .. vim.treesitter.get_node_text(node, 0)[1]
    end
  },
}
