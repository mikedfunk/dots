if vim.fn.executable('jq-lsp') == 1 then
else
  vim.notify_once("Installing jq-lsp", vim.log.levels.INFO)
  vim.cmd 'MasonInstall jq-lsp'
end

vim.lsp.start {
  name = 'jq',
  cmd = {'jq-lsp'},
  root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
}
