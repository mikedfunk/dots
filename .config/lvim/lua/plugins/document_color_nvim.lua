-- tailwind color previewing
local is_installed = require 'helpers'.is_installed

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("document_color_lspattach", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client.server_capabilities.colorProvider then return end
    if not is_installed('document-color') then return end

    require('document-color').buf_attach(bufnr)
  end
})

return { 'mrshmllow/document-color.nvim' }
