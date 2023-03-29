local function setup_language_server()
  vim.lsp.start {
    name = 'jq',
    cmd = {'jq-lsp'},
    root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
  }
end

if vim.fn.executable('jq-lsp') == 1 then
  setup_language_server()
else
  local is_mason_installed, registry = pcall(require, 'mason-registry')
  if is_mason_installed and not registry.is_installed('jq-lsp') then
    vim.notify_once("Installation in progress for jq-lsp", vim.log.levels.INFO)
    local package = registry.get_package('jq-lsp')
    package:install():once('closed', function()
      if package:is_installed() then
        vim.schedule(function()
          vim.notify_once('Installation complete for jq-lsp', vim.log.levels.INFO)
          setup_language_server()
        end)
      end
    end)
  else
  end
end
