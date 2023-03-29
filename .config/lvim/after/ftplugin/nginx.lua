local function setup_language_server()
  vim.lsp.start {
    name = 'nginx_ls',
    cmd = {'nginx-language-server'},
    root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
  }
end

if vim.fn.executable('nginx-language-server') == 1 then
  setup_language_server()
else
  local is_mason_installed, registry = pcall(require, 'mason-registry')
  if is_mason_installed and not registry.is_installed('nginx-language-server') then
    vim.notify_once("Installation in progress for nginx-language-server", vim.log.levels.INFO)
    local package = registry.get_package('nginx-language-server')
    package:install():once('closed', function()
      if package:is_installed() then
        vim.schedule(function()
          vim.notify_once('Installation complete for nginx-language-server', vim.log.levels.INFO)
          setup_language_server()
        end)
      end
    end)
  end
end
