if vim.fn.executable('nginx-language-server') == 1 then
else
  vim.notify_once("Installing nginx-language-server", vim.log.levels.INFO)
  vim.cmd 'MasonInstall nginx-language-server'
end

vim.lsp.start {
  name = 'nginx_ls',
  cmd = {'nginx-language-server'},
  root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
}
