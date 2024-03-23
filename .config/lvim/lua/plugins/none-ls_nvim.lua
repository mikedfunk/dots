-- vim: set foldmethod=marker:
-- TODO: rewrite without lvim global object
lvim.lsp.null_ls.setup.debounce = 1000
lvim.lsp.null_ls.setup.default_timeout = 30000
local is_null_ls_installed, null_ls = pcall(require, 'null-ls') ---@diagnostic disable-line redefined-local
-- lvim.lsp.null_ls.setup.debug = true -- turn on debug null-ls logging: tail -f ~/.cache/nvim/null-ls.log

-- linters {{{

require 'lvim.lsp.null-ls.linters'.setup {
  -- {
  --   name = 'codespell',
  --   -- force the severity to be HINT
  --   diagnostics_postprocess = function(diagnostic)
  --     diagnostic.severity = vim.diagnostic.severity.HINT
  --   end,
  --   extra_args = { '--ignore-words-list', 'tabe,noice' },
  -- },
  {
    name = 'cspell',
    filetypes = {
      'php',
      'python',
      'ruby',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    -- force the severity to be HINT
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity.HINT
    end,
  },
  -- { name = 'mypy', condition = function() return vim.fn.executable 'mypy' == 1 end }, -- disabled for ruff instead
  -- { name = 'pycodestyle', condition = function() return vim.fn.executable 'pycodestyle' == 1 end }, -- disabled for ruff instead
  -- { name = 'dotenv_linter' }, -- not available in Mason
  -- { name = 'luacheck' },
  { name = 'eslint_d' }, -- until I can get the eslint-lsp to work again
  -- { name = 'todo_comments' },
  { name = 'gitlint' },
  { name = 'semgrep' },
  { name = 'editorconfig_checker', filetypes = { 'editorconfig' } },
  -- { name = 'checkmake' }, -- makefile linter
  -- moved to ALE to avoid zombie process
  -- {
  --   name = 'phpcs',
  --   timeout = 30000,
  --   extra_args = {
  --     '--cache',
  --     '--warning-severity=3',
  --     '-d',
  --     'memory_limit=100M',
  --     -- '-d',
  --     -- 'xebug.mode=off',
  --   },
  --   condition = function(utils)
  --     return vim.fn.executable 'phpcs' == 1 and utils.root_has_file { 'phpcs.xml' }
  --   end,
  -- },
  -- moved to ALE to avoid zombie process
  -- {
  --   name = 'phpstan',
  --   timeout = 30000,
  --   extra_args = {
  --     '--memory-limit=200M',
  --     '--level=9', -- force level 9 for better editor intel
  --   }, -- 40MB is not enough
  --   condition = function(utils)
  --     return utils.root_has_file { 'phpstan.neon' }
  --   end,
  -- },
  { name = 'php' },
  -- { name = 'rubocop' },
  -- { name = 'spectral' },
  {
    name = 'shellcheck',
    condition = function() return not vim.tbl_contains({'.env', '.env.example'}, vim.fn.expand('%:t')) end,
  },
  { name = 'sqlfluff', extra_args = { '--dialect', 'mysql' } },
  { name = 'trail_space' },
  -- { name = 'vacuum' }, -- openapi linter. Much simpler and more stable than spectral.
  { name = 'zsh' },
}

-- local did_register_spectral
-- if is_null_ls_installed and not did_register_spectral then
--   null_ls.register { sources = {
--     null_ls.builtins.diagnostics.spectral.with {
--       command = { 'npx', '@stoplight/spectral-cli' }, -- damn it... LunarVim overrides the command now. Gotta do it from null-ls instead.
--       condition = function(utils) return utils.root_has_file { '.spectral.yaml' } end,
--     }
--   } }
--   did_register_spectral = true
-- end

-- }}}

-- formatters {{{
require 'lvim.lsp.null-ls.formatters'.setup {
  { name = 'black' },
  { name = 'eslint_d' }, -- until I can get the eslint-lsp to start working again
  { name = 'isort' },
  { name = 'blade_formatter' },
  { name = 'cbfmt' }, -- for formatting code blocks inside markdown and org documents
  { name = 'shfmt' },
  { name = 'json_tool', extra_args = { '--indent=2' } },
  -- { name = 'stylua' }, -- config doesn't seem to be working, even global
  -- moved to null-ls setup directly because lunarvim won't let me change the command
  -- {
  --   name = 'phpcbf',
  --   command = vim.env.HOME .. '/.support/phpcbf-helper.sh', -- damn it... they override the command now. Gotta do it from null-ls instead. https://github.com/lunarvim/lunarvim/blob/c18cd3f0a89443d4265f6df8ce12fb89d627f09e/lua/lvim/lsp/null-ls/services.lua#L81
  --   extra_args = { '-d', 'memory_limit=60M', '-d', 'xdebug.mode=off', '--warning-severity=0' }, -- do not fix warnings
  --   -- timeout = 20000,
  --   condition = function(utils)
  --     return vim.fn.executable 'phpcbf' == 1 and utils.root_has_file { 'phpcs.xml' }
  --   end,
  -- },
  {
    name = 'phpcsfixer',
    extra_args = { '--config=.php-cs-fixer.php' },
    timeout = 20000,
    condition = function(utils)
      -- return vim.fn.executable 'php-cs-fixer' == 1 and vim.fn.filereadable '.php-cs-fixer.php' == 1
      return utils.root_has_file { '.php-cs-fixer.php' }
    end,
  },
  {
    name = 'prettier',
    condition = function(utils)
      -- phew! https://prettier.io/docs/en/configuration.html
      return utils.root_has_file {
        'prettier.config.js',
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.yml',
        '.prettierrc.yaml',
        '.prettierrc.json5',
        '.prettierrc.js',
        'prettierrc.config.js',
        '.prettierrc.mjs',
        'prettierconfig.mjs',
        '.prettierrc.cjs',
        'prettier.config.cjs',
        '.prettierrc.toml',
      }
    end
  }, -- had problems with prettierd for some reason
  {
    name = 'rustywind', -- organizes tailwind classes
    condition = function(utils)
      -- return vim.fn.executable 'rustywind' == 1 and vim.fn.filereadable 'tailwind.config.js' == 1
      return utils.root_has_file { 'tailwind.config.js' }
    end
  },
  -- { name = 'sql_formatter', condition = function() return vim.fn.executable 'sql-formatter' == 1 end }, -- mangles variables
  {
    name = 'sqlfluff',
    extra_args = { '--dialect', 'mysql' },
    condition = function() return vim.fn.executable('sqlfluff') == 1 end,
  },
  -- -- { name = 'trim_newlines' },
  -- { name = 'trim_whitespace' },
}

local did_register_phpcbf
if is_null_ls_installed and not did_register_phpcbf then
  null_ls.register { sources = {
    null_ls.builtins.formatting.phpcbf.with {
      command = vim.env.HOME .. '/.support/phpcbf-helper.sh', -- damn it... LunarVim overrides the command now. Gotta do it from null-ls instead.
      extra_args = { '-d', 'memory_limit=60M', '-d', 'xdebug.mode=off', '-w', '--warning-severity=3' },
      -- condition = function()
      --   -- return utils.is_exectuable 'phpcbf' and utils.root_has_file { 'phpcs.xml' }
      --   return vim.fn.executable 'phpcbf' == 1 and vim.fn.filereadable 'phpcs.xml' == 1
      -- end,
    }
  } } -- @diagnostic disable-line redundant-parameter
  did_register_phpcbf = true
end
-- }}}

-- code actions {{{
require 'lvim.lsp.null-ls.code_actions'.setup {
  { name = 'cspell' },
  { name = 'eslint_d' }, -- until I can get eslint-lsp to start working
  { name = 'gitrebase' }, -- just provides helpers to switch pick to fixup, etc.
  -- adds a LOT of null-ls noise, not that useful
  {
    name = 'gitsigns',
    condition = function()
      local is_gitsigns_installed, _ = pcall(require, 'gitsigns')
      return is_gitsigns_installed
    end,
    config = { filter_actions = function(title) return title:lower():match("blame") == nil end },
  },
  { name = 'refactoring' },
  -- { name = 'proselint' }, -- trying this out for markdown
  -- { name = 'ts_node_action' },
}
-- }}}

-- completion {{{
local did_register_spell
if is_null_ls_installed and not did_register_spell then
  null_ls.register { sources = {
    null_ls.builtins.completion.spell.with {
      filetypes = { 'markdown' },
      runtime_condition = function() return vim.wo.spell end,
    }
  } }
  did_register_spell = true
end ---@diagnostic disable-line redundant-parameter
-- }}}

-- hover {{{
local did_register_printenv
if is_null_ls_installed and not did_register_printenv then
  null_ls.register { sources = { null_ls.builtins.hover.printenv } }
  did_register_printenv = true
end
-- }}}

return {}
