return {
  -- TODO: https://github.com/Wansmer/treesj
  "AndrewRadev/splitjoin.vim",
  branch = "main",
  event = "VeryLazy",
  init = function()
    vim.g["splitjoin_php_method_chain_full"] = 1
    vim.g["splitjoin_quiet"] = 1
    -- vim.g['splitjoin_trailing_comma'] = require 'saatchiart.plugin_configs'.should_enable_trailing_commas() and 1 or 0
  end,
}
