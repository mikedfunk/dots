-- vim: set foldmethod=marker:
-- TODO: rewrite without lvim global object

-- lvim.lsp.installer.setup.automatic_installation = { exclude = { 'phpactor' } }

-- NOTE: this is not just ensure installed, if these have language server
-- configs it will try to set them up as language servers. This is not what
-- I want for phpactor for instance. You must use the same keys as from
-- nvim-lspconfig. This does not include non-lsp tools.

-- contextive language server (not in mason-lspconfig or nvim-lspconfig pinned versions in LunarVim yet) {{{
local function setup_contextive_ls()
  local is_nvim_lsp_installed, nvim_lsp = pcall(require, 'lspconfig')
  if is_nvim_lsp_installed and not require 'lspconfig.configs'.contextive then
    require 'lspconfig.configs'.contextive = {
      default_config = {
        cmd = { 'Contextive.LanguageServer' },
        root_dir = nvim_lsp.util.root_pattern('.contextive', '.git'),
      };
    }
  end
  require 'lspconfig'.contextive.setup { autostart = false }
end

if vim.fn.executable('Contextive.LanguageServer') == 1 then
  setup_contextive_ls()
else
  local is_mason_installed, registry = pcall(require, 'mason-registry')
  if is_mason_installed and not registry.is_installed('contextive') then
    vim.notify_once("Installation in progress for contextive", vim.log.levels.INFO)
    local package = registry.get_package('contextive')
    package:install():once('closed', function()
      if package:is_installed() then
        vim.schedule(function()
          vim.notify_once('Installation complete for contextive', vim.log.levels.INFO)
          setup_contextive_ls()
        end)
      end
    end)
  end
end
-- }}}

-- when you run :LvimCacheReset
-- this will GENERATE an ftplugin to run lspconfig setup with no opts!
-- https://github.com/LunarVim/LunarVim/blob/30c65cfd74756954779f3ea9d232938e642bc07f/lua/lvim/lsp/templates.lua
-- available keys are here: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
lvim.lsp.installer.setup.ensure_installed = {
  'cssls',
  'cucumber_language_server',
  'docker_compose_language_service',
  'dockerls',
  'emmet_language_server',
  'intelephense',
  'jsonls',
  'lemminx',
  'lua_ls', -- aka sumneko_lua
  'ruff_lsp', -- python linter lsp (replaces flake8)
  'sqlls', -- https://github.com/joe-re/sql-language-server/issues/128
  'tailwindcss',
  'taplo',
  'yamlls',
  'zk',
  -- 'astro',
  -- 'autotools-language-server', -- TODO: enable this once mason-lspconfig is upgraded
  -- 'bashls',
  -- 'contextive', -- DDD definition helper (not in mason-lspconfig yet)
  -- 'cssmodules_ls',
  -- 'denols',
  -- 'emberls',
  -- 'eslint', -- eslint-lsp (stopped working on node 17.8.0, lsp debug isn't showing any errors)
  -- 'glint', -- typed ember
  -- 'graphql',
  -- 'jqls',
  -- 'nginx_language_server', -- not in mason-lspconfig yet
  -- 'phpactor', -- I use intelephense. This requires PHP 8.0+.
  -- 'prismals', -- node ORM
  -- 'pyright', -- just use ruff-lsp
  -- 'relay_lsp', -- react framework
  -- 'remark_ls',
  -- 'ruby_ls', -- using the recommended solargraph instead
  -- 'snyk-ls', -- not on null-ls or nvim-lspconfig yet
  -- 'solargraph',
  -- 'sqls' -- just doesn't do anything, is archived
  -- 'svelte',
  -- 'tsserver', -- handled by typescript.nvim instead
  -- 'vimls',
  -- 'vuels',
}

lvim.lsp.document_highlight = true

-- remove toml from skipped filetypes so I can configure taplo
lvim.lsp.automatic_configuration.skipped_filetypes = vim.tbl_filter(function(val)
  return not vim.tbl_contains({ 'toml' }, val)
end, lvim.lsp.automatic_configuration.skipped_filetypes)

for _, server in pairs({
  'phpactor', -- requires php 8.0+
  'tsserver',
  -- 'intelephense',
  -- 'solargraph',
  -- 'standardrb',
}) do
  if not vim.tbl_contains(lvim.lsp.automatic_configuration.skipped_servers, server) then
    table.insert(lvim.lsp.automatic_configuration.skipped_servers, server)
  end
end

-- flow: moved to ./after/ftplugin/javascript.lua
-- tsserver: moved to typescript.nvim

-- snyk-ls {{{
-- commented out because this opens a browser window every time to login :(
-- local function setup_language_server()
--   vim.lsp.start {
--     name = 'snyk_ls',
--     cmd = {'snyk-ls'},
--     settings = {
--       token = vim.env.SNYK_TOKEN
--     },
--     root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
--   }
-- end

-- if vim.fn.executable('snyk-ls') == 1 then
--   setup_language_server()
-- else
--   local is_mason_installed, registry = pcall(require, 'mason-registry')
--   if is_mason_installed and not registry.is_installed('snyk-ls') then
--     vim.notify_once("Installation in progress for snyk-ls", vim.log.levels.INFO)
--     local package = registry.get_package('snyk-ls')
--     package:install():once('closed', function()
--       if package:is_installed() then
--         vim.schedule(function()
--           vim.notify_once('Installation complete for snyk-ls', vim.log.levels.INFO)
--           setup_language_server()
--         end)
--       end
--     end)
--   end
-- end
-- }}}

return {}
