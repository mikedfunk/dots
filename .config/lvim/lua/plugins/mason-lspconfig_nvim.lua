-- TODO: rewrite without lvim global object

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
  -- 'zk',
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

return {}
