vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("nvim_lightbulb_lspattach", { clear = true }),
  pattern = "*",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.codeActionProvider == false then return end

    local is_nvim_lightbulb_installed, nvim_lightbulb = pcall(require, 'nvim-lightbulb')
    if not is_nvim_lightbulb_installed then return end

    -- vim.cmd "autocmd CursorHold,CursorHoldI * lua require 'nvim-lightbulb'.update_lightbulb{}"
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      pattern = '*',
      group = vim.api.nvim_create_augroup('nvim_lightbulb', { clear = true }),
      desc = 'nvim lightbulb update',
      callback = nvim_lightbulb.update_lightbulb,
    })
  end
})

return {
  'kosayoda/nvim-lightbulb',
  -- init = function()
  --   vim.fn.sign_define('LightBulbSign', { text = '', texthl = 'DiagnosticSignWarn' })
  -- end,
  opts = {
    sign = {
      text = '',
      hl = 'DiagnosticSignWarn',
    }
  }
}
