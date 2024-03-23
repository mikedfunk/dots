-- tailwind color previewing
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("document_color_lspattach", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client.server_capabilities.colorProvider then return end
    local is_document_color_installed, _ = pcall(require, 'document-color')
    if not is_document_color_installed then return end

    require('document-color').buf_attach(bufnr)
  end
})

return { 'mrshmllow/document-color.nvim' }
