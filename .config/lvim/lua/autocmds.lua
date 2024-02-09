-- vim: set foldmethod=marker:

-- Define an autocmd group for the blade workaround {{{
-- https://github.com/kauffinger/lazyvim/blob/e060b5503b87118a7ad164faed38dff3ec408f3e/lua/config/autocmds.lua#L5
-- TODO: this workaround does not work
vim.api.nvim_create_augroup("lsp_blade_workaround", { clear = true })

-- Autocommand to temporarily change 'blade' filetype to 'php' when opening for LSP server activation
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "lsp_blade_workaround",
  pattern = "*.blade.php",
  callback = function()
    vim.bo.filetype = "php"
  end,
})

-- Additional autocommand to switch back to 'blade' after LSP has attached
vim.api.nvim_create_autocmd("LspAttach", {
  group = "lsp_blade_workaround",
  pattern = "*.blade.php",
  callback = function(args)
    vim.schedule(function()
      -- Check if the attached client is 'intelephense'
      for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.name == "intelephense" and client.attached_buffers[args.buf] then
          vim.api.nvim_buf_set_option(args.buf, "filetype", "blade")
          break
        end
      end
    end)
  end,
})
-- }}}

-- lvim lsp custom on_attach {{{

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("all_lsp_attach", { clear = true }),
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.keymap.set('i', '<c-v>', function() vim.lsp.buf.signature_help() end, { buffer = bufnr, noremap = true })
    vim.keymap.set('i', '<c-k>', function() vim.lsp.buf.signature_help() end, { buffer = bufnr, noremap = true })

    if client.server_capabilities.document_formatting == true then
      vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})')
    end

    if client.server_capabilities.goto_definition == true then
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
    end
  end
})
-- }}}
