-- TODO: rewrite without lvim global object
return {
  'hrsh7th/cmp-nvim-lsp-signature-help',
  dependencies = 'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  init = function()
    if vim.tbl_contains(lvim.builtin.cmp.sources, { name = 'nvim_lsp_signature_help' }) then return end
    table.insert(lvim.builtin.cmp.sources, {
      name = 'nvim_lsp_signature_help',
      -- preselect = require 'cmp'.PreselectMode.None,
    })
  end,
}
