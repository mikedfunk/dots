vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("nvim_lightbulb_lspattach", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    local is_lsp_inlayhints_installed, lsp_inlayhints = pcall(require, 'lsp-inlayhints')
    if not is_lsp_inlayhints_installed then return end
    lsp_inlayhints.on_attach(client, bufnr)
    -- vim.cmd 'hi link LspInlayHint Comment'
  end
})

return {
  'lvimuser/lsp-inlayhints.nvim',
  opts = {}
}
