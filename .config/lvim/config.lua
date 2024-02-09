-- vim: set foldmethod=marker:

require 'options'
require 'keymaps'
require 'autocmds'
local is_installed = require 'helpers'.is_installed

lvim.format_on_save.pattern = table.concat({
  '*.css',
  '*.js',
  '*.jsx',
  '*.lua',
  '*.md',
  '*.php',
  '*.tsx',
  '*.yml',
}, ',')
lvim.format_on_save.timeout = 30000

-- icons {{{
lvim.icons.git.FileUnstaged = '✎'
-- lvim.icons.git.FileUntracked = '󱙄'
lvim.icons.git.FileUntracked = '󱃓'
lvim.icons.git.FileStaged = '✓'
-- }}}

-- language servers {{{
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

-- }}}

-- builtin plugins {{{

lvim.builtin.bufferline.active = true -- bufferline.nvim
lvim.builtin.dap.active = true -- nvim-dap
lvim.builtin.alpha.active = false -- alpha.nvim
lvim.builtin.lualine.active = true
-- lvim.builtin.notify.active = true -- nvim-notify
lvim.builtin.terminal.active = true -- toggleterm.nvim (useful to tail logs with <leader>Ll..)

-- bufferline.nvim {{{
vim.cmd [[hi! default link PanelHeading BufferLineTabSelected]]
vim.api.nvim_create_augroup('bufferline_fill_fix', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'bufferline_fill_fix',
  callback = function() vim.cmd [[silent! hi! link BufferLineFill BufferLineGroupSeparator]] end,
})

-- -- Bufferline tries to make everything italic. Why?
-- moved to no_italic below
-- lvim.builtin.bufferline.highlights.background = { italic = false }
-- lvim.builtin.bufferline.highlights.buffer_selected.italic = false
-- lvim.builtin.bufferline.highlights.diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.hint_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.hint_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.info_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.info_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.warning_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.warning_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.error_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.error_diagnostic_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate_visible = { italic = false }
-- lvim.builtin.bufferline.highlights.duplicate = { italic = false }
-- lvim.builtin.bufferline.highlights.pick_selected = { italic = false }
-- lvim.builtin.bufferline.highlights.pick_visible = { italic = false }
-- lvim.builtin.bufferline.highlights.pick = { italic = false }

lvim.builtin.bufferline.options.persist_buffer_sort = true
lvim.builtin.bufferline.options.hover.enabled = true
lvim.builtin.bufferline.options.sort_by = 'insert_after_current'
lvim.builtin.bufferline.options.always_show_bufferline = true
lvim.builtin.bufferline.options.separator_style = 'slant'
-- lvim.builtin.bufferline.options.numbers = 'ordinal'

-- remove all sidebar headers
for k, _ in ipairs(lvim.builtin.bufferline.options.offsets) do
  lvim.builtin.bufferline.options.offsets[k].text = nil
end

if is_installed('bufferline') then
  lvim.builtin.bufferline.options.groups = lvim.builtin.bufferline.options.groups or {}
  lvim.builtin.bufferline.options.groups.items = lvim.builtin.bufferline.options.groups.items or {}
  table.insert(
    lvim.builtin.bufferline.options.groups.items,
    require 'bufferline.groups'.builtin.pinned:with { icon = "" }
  )

  lvim.builtin.bufferline.options.style_preset = require 'bufferline'.style_preset.no_italic
end
-- }}}

-- gitsigns.nvim {{{

lvim.builtin.gitsigns.opts.yadm.enable = true

-- consistency with nvim-tree and makes more sense than the default
lvim.builtin.gitsigns.opts.signs.delete.text = ''
lvim.builtin.gitsigns.opts.signs.topdelete.text = ''
-- }}}

-- indent-blankline.nvim {{{
if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'mason') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'mason') end
if not vim.tbl_contains(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') then table.insert(lvim.builtin.indentlines.options.filetype_exclude, 'lspinfo') end
lvim.builtin.indentlines.options.show_first_indent_level = false
-- }}}

-- lir.nvim {{{
-- There is a bug in the autocmd to fire DirOpened, which enables lir. Just load it.
vim.api.nvim_create_augroup('force_load_lir', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'force_load_lir',
  callback = function() vim.cmd 'do User DirOpened' end,
})
-- }}}

-- lualine {{{
lvim.builtin.lualine.style = 'default'
lvim.builtin.lualine.options.disabled_filetypes = { 'startify', 'TelescopePrompt' }
lvim.builtin.lualine.extensions = { 'quickfix', 'nvim-tree', 'symbols-outline', 'fugitive' } -- https://github.com/nvim-lualine/lualine.nvim#extensions

local components = require 'lvim.core.lualine.components'

components.filetype.on_click = function() vim.cmd 'Telescope filetypes theme=get_ivy' end

-- match icons with the ones in the signs column
local diagnostics_component = components.diagnostics
diagnostics_component.symbols.error = lvim.icons.diagnostics.Error .. ' '
diagnostics_component.symbols.hint = lvim.icons.diagnostics.Hint .. ' '
diagnostics_component.symbols.info = lvim.icons.diagnostics.Information .. ' '
diagnostics_component.symbols.warn = lvim.icons.diagnostics.Warning .. ' '
diagnostics_component.on_click = function() vim.cmd 'Telescope diagnostics bufnr=0 theme=get_ivy' end

local lsp_component = {
  -- remove null_ls from lsp clients, adjust formatting
  ---@param message string
  ---@return string
  function(message)
    local buf_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
    if buf_clients and next(buf_clients) == nil then
      if type(message) == 'boolean' or #message == 0 then return '' end
      return message
    end

    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= 'null-ls' then table.insert(buf_client_names, client.name) end
    end

    buf_client_names = vim.fn.uniq(buf_client_names) ---@diagnostic disable-line missing-parameter

    -- no longer needed with full width statusbar
    -- if vim.fn.winwidth(0) < 150 and #(buf_client_names) > 1 then return #(buf_client_names) end

    local number_to_show = 1
    local first_few = vim.list_slice(buf_client_names, 1, number_to_show)
    local extra_count = #(buf_client_names) - number_to_show
    local output = table.concat(first_few, ', ')
    if extra_count > 0 then output = output .. ' +' .. extra_count end
    return output
  end,
  icon = { 'ʪ', color = { fg = require 'lvim.core.lualine.colors'.blue } },
  color = { gui = 'None' },
  on_click = function() vim.cmd 'LspInfo' end,
}

local codeium_status_component = {
  ---@return string
  function(_) return '' end,
  separator = { right = '' },
  color = function()
    if not vim.fn.exists('codeium#Enabled') then
      return { fg = require 'lvim.core.lualine.colors'.red }
    end

    if not vim.fn['codeium#Enabled']() then
      return { fg = require 'lvim.core.lualine.colors'.red }
    end

    return { fg = require 'lvim.core.lualine.colors'.green }
  end,
  -- cond = function()
  --   local success, _ = pcall(vim.cmd, 'Codeium')
  --   return success
  -- end,
  on_click = function()
    if vim.fn.exists('codeium#Enabled') == 0 then return end
    if vim.fn['codeium#Enabled']() then
      vim.cmd 'CodeiumDisable'
    else
      vim.cmd 'CodeiumEnable'
    end
  end,
}

local codeium_component = {
  ---@return string
  function(_)
    local response = vim.fn['codeium#GetStatusString']()
    response = vim.trim(response)
    if response == 'ON' or response == 'OFF' then return '' end
    return response
  end,
  padding = { left = 0, right = 1 },
  cond = function()
    local installed, _ = pcall(vim.cmd, 'Codeium')
    return installed
  end,
}

local null_ls_component = {
  ---@param message string
  ---@return string
  function(message)
    local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
    if buf_clients and next(buf_clients) == nil then
      if type(message) == 'boolean' or #message == 0 then return '' end
      return message
    end
    local buf_client_names = {}

    if is_installed('null-ls') then
      for _, source in pairs(require 'null-ls.sources'.get_available(vim.bo.filetype)) do
        table.insert(buf_client_names, source.name)
      end
    end

    -- no longer needed with full width statusbar
    -- if vim.fn.winwidth(0) < 150 and #(buf_client_names) > 1 then return #(buf_client_names) end

    local number_to_show = 1
    local first_few = vim.list_slice(buf_client_names, 1, number_to_show)
    local extra_count = #(buf_client_names) - number_to_show
    local output = table.concat(first_few, ', ')
    if extra_count > 0 then output = output .. ' +' .. extra_count end
    return output
  end,
  color = { gui = 'None' --[[, fg = require"lvim.core.lualine.colors".purple]] },
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.purple } },
  cond = function() return is_installed 'null-ls' and require 'lvim.core.lualine.conditions'.hide_in_width() end,
  on_click = function() require 'null-ls.info'.show_window { border = 'rounded' } end,
}

local cmp_component = {
  ---@param _ string
  ---@return string
  function(_)
    local is_cmp_installed, cmp = pcall(require, 'cmp')
    if not is_cmp_installed then return '' end
    local config = require 'cmp.config'
    local sources = {}

    for _, s in pairs(cmp.core.sources) do
      if config.get_source_config(s.name) then
        if s:is_available() then
          table.insert(sources, s:get_debug_name())
        end
      end
    end

    local number_to_show = 1
    local first_few = vim.list_slice(sources, 1, number_to_show)
    local extra_count = #(sources) - number_to_show
    local output = table.concat(first_few, ', ')
    if extra_count > 0 then output = output .. ' +' .. extra_count end
    return output
  end,
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.green } },
  cond = function() return is_installed 'cmp' and require 'lvim.core.lualine.conditions'.hide_in_width() end,
  on_click = function() vim.cmd 'CmpStatus' end,
}

---@return string
local dap_component = {
  function()
    local is_dap_installed, dap = pcall(require, 'dap')
    if is_dap_installed then return dap.status() else return '' end
  end,
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.yellow } },
  cond = function()
    local is_dap_installed, dap = pcall(require, 'dap')
    return is_dap_installed and dap.status ~= ''
  end,
}

---@return string
local ale_linters_and_fixers_component = {
  function()
    local filetype = vim.bo.filetype
    if filetype == '' then return '' end
    local is_ale_installed, linter_details = pcall(vim.call, 'ale#linter#Get', filetype)
    if not is_ale_installed then return '' end

    ---@type table<integer, string>
    local ale_linters = vim.tbl_map(function(linter) return linter.name end, linter_details) ---@diagnostic disable-line assign-mismatch
    ---@type table<integer, string>
    local ale_fixers = vim.tbl_flatten({
      (vim.g['ale_fixers'] or {})[filetype] or {},
      vim.b[vim.api.nvim_get_current_buf()].ale_fixers or {},
    })
    ---@type table<integer, string>
    local linters_and_fixers = vim.tbl_flatten({ ale_linters, ale_fixers })
    if #(linters_and_fixers) == 0 then return '' end

    local output = table.remove(linters_and_fixers, 1)
    if #(linters_and_fixers) > 0 then output = output .. ' +' .. #(linters_and_fixers) end

    local is_ale_checking_buffer = vim.call('ale#engine#IsCheckingBuffer', vim.call('bufnr', ''))
    if is_ale_checking_buffer == 1 then output = output .. ' …' end

    return output
  end,
  -- color = { gui = 'None', fg = require'lvim.core.lualine.colors'.magenta },
  icon = { '', color = { fg = require 'lvim.core.lualine.colors'.violet } },
  on_click = function() vim.cmd 'ALEInfo' end,
}

lvim.builtin.lualine.sections.lualine_x = {
  diagnostics_component,
  lsp_component,
  ale_linters_and_fixers_component,
  null_ls_component,
  cmp_component,
}
-- lvim.builtin.lualine.sections.lualine_y = {}
-- lvim.builtin.lualine.sections.lualine_z = {}
-- lvim.builtin.lualine.sections.lualine_a = {}

-- components.branch.on_click = function() vim.cmd 'Git' end
-- components.branch.color = { gui = 'None' }

-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict ---@diagnostic disable-line undefined-field
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

components.diff.source = diff_source
components.diff.cond = function() return require 'lvim.core.lualine.conditions'.hide_in_width() end

lvim.builtin.lualine.sections.lualine_b = {
  -- components.branch,
  {
    'branch',
    icon = { lvim.icons.git.Branch },
    on_click = function() vim.cmd 'Git' end,
  },
}

components.spaces.separator = nil
components.spaces.cond = function() return require 'lvim.core.lualine.conditions'.hide_in_width() end

components.treesitter.on_click = function() vim.cmd 'TSInstallInfo' end -- doesn't work right

local current_session_component = {
  function()
    local session_name, _ = vim.v.this_session:gsub('^(.*/)(.*)$', '%2')
    return session_name
  end,
  cond = function() return vim.v.this_session ~= nil end,
  icon = { lvim.icons.ui.BookMark, color = { fg = require 'lvim.core.lualine.colors'.cyan } },
}

-- lualine builtin is not working for some reason
local search_count_component = {
  function()
    if vim.v.hlsearch == 0 then
      return ''
    end

    local result = vim.fn.searchcount { maxcount = 999, timeout = 500 }
    local denominator = math.min(result.total, result.maxcount)
    return string.format('[%d/%d]', result.current, denominator)
  end,
  { icon = { lvim.icons.ui.Search } },
}

local macro_component = {
  function()
    if vim.fn.reg_recording() == '' then return '' end
    return 'Recording: ' .. vim.fn.reg_recording()
  end,
  icon = { lvim.icons.ui.Circle, color = { fg = require 'lvim.core.lualine.colors'.red, gui = 'Bold' } },
  cond = function()
    return vim.fn.reg_recording() ~= '' and require 'lvim.core.lualine.conditions'.hide_in_width()
  end,
}

lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  components.filetype,
  components.treesitter,
  current_session_component,
  components.spaces,
  dap_component,
  search_count_component, -- useful for cmdheight=0
  macro_component,
  codeium_status_component,
  codeium_component,
}

-- }}}

-- luasnip {{{
lvim.builtin.luasnip.build = "make install_jsregexp" -- TODO this doesn't work
-- lvim.builtin.luasnip.update_events = { "TextChanged", "TextChangedI" } -- also not working
if is_installed('luasnip') then
  -- show transformations while you type
  require 'luasnip'.config.setup {
    update_events = { "TextChanged", "TextChangedI" },
  }
  -- strangely these aren't mapped by LunarVim. Doesn't work with noremap... i think because it's already mapped by something else
  vim.keymap.set('i', '<C-E>', '<Plug>luasnip-next-choice', {})
  vim.keymap.set('s', '<C-E>', '<Plug>luasnip-next-choice', {})
end
-- }}}

-- mason.nvim {{{
lvim.builtin.mason.ui.border = 'rounded'
-- lvim.builtin.mason.log_level = vim.log.levels.DEBUG
lvim.builtin.mason.ui.icons = {
  package_installed = lvim.icons.ui.Check,
  package_pending = lvim.icons.ui.BoldArrowRight,
  package_uninstalled = lvim.icons.ui.Close,
}
-- }}}

-- nvim-cmp {{{

lvim.builtin.cmp.cmdline.enable = true

-- table.insert(lvim.builtin.cmp.cmdline.options[2].sources, { name = 'nvim_lsp_document_symbol' })

-- lvim.builtin.cmp.experimental.ghost_text = true

lvim.builtin.cmp.formatting.source_names['buffer'] = ''
lvim.builtin.cmp.formatting.source_names['buffer-lines'] = '≡'
lvim.builtin.cmp.formatting.source_names['calc'] = ''
lvim.builtin.cmp.formatting.source_names['cmp_jira'] = ''
lvim.builtin.cmp.formatting.source_names['cmp_tabnine'] = '󰚩' --  ➒
lvim.builtin.cmp.formatting.source_names['color_names'] = ''
lvim.builtin.cmp.formatting.source_names["copilot"] = ""
lvim.builtin.cmp.formatting.source_names['dap'] = ''
lvim.builtin.cmp.formatting.source_names['dictionary'] = ''
lvim.builtin.cmp.formatting.source_names['doxygen'] = '' -- 󰙆
lvim.builtin.cmp.formatting.source_names['emoji'] = '' -- 
lvim.builtin.cmp.formatting.source_names['git'] = ''
lvim.builtin.cmp.formatting.source_names['jira_issues'] = ''
lvim.builtin.cmp.formatting.source_names['luasnip'] = '✄'
lvim.builtin.cmp.formatting.source_names['luasnip_choice'] = ''
lvim.builtin.cmp.formatting.source_names['marksman'] = '󰓾' -- 🞋
lvim.builtin.cmp.formatting.source_names['nerdfont'] = '󰬴'
lvim.builtin.cmp.formatting.source_names['nvim_lsp'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_document_symbol'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lsp_signature_help'] = 'ʪ'
lvim.builtin.cmp.formatting.source_names['nvim_lua'] = ''
lvim.builtin.cmp.formatting.source_names['path'] = '󰉋' --  
lvim.builtin.cmp.formatting.source_names['plugins'] = '' --  
lvim.builtin.cmp.formatting.source_names['rg'] = ''
lvim.builtin.cmp.formatting.source_names['tmux'] = ''
lvim.builtin.cmp.formatting.source_names['treesitter'] = ''
lvim.builtin.cmp.formatting.source_names['vsnip'] = '✄'
lvim.builtin.cmp.formatting.source_names['zk'] = ''

lvim.builtin.cmp.formatting.kind_icons.Method = lvim.icons.kind.Method -- default is 
lvim.builtin.cmp.formatting.kind_icons.Function = lvim.icons.kind.Function -- default is ƒ

local is_cmp_installed, cmp = pcall(require, 'cmp')
if is_cmp_installed then lvim.builtin.cmp.preselect = cmp.PreselectMode.None end
lvim.builtin.cmp.mapping['<C-J>'] = lvim.builtin.cmp.mapping['<Tab>']
lvim.builtin.cmp.mapping['<C-K>'] = lvim.builtin.cmp.mapping['<S-Tab>']

-- lvim.builtin.cmp.mapping['<C-Y>'] = function() require 'cmp'.mapping.confirm({ select = false }) end -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
-- }}}

-- null-ls / none-ls {{{
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

-- code actions {{{
require 'lvim.lsp.null-ls.code_actions'.setup {
  { name = 'cspell' },
  { name = 'eslint_d' }, -- until I can get eslint-lsp to start working
  { name = 'gitrebase' }, -- just provides helpers to switch pick to fixup, etc.
  -- adds a LOT of null-ls noise, not that useful
  {
    name = 'gitsigns',
    condition = function() return is_installed 'gitsigns' end,
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

-- }}}

-- }}}

-- nvim-dap {{{
-- require 'dap'.set_log_level('DEBUG') -- debug dap: tail -f ~/.cache/nvim/dap.log

vim.api.nvim_create_augroup('dap_attach', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  group = 'dap_attach',
  callback = function() require 'dap.ext.autocompl'.attach() end,
})

local register_dap_adapters = function()
  local dap = require 'dap'
  dap.adapters.php = {
    type = 'executable',
    command = 'php-debug-adapter', -- this calls the same thing below
    -- command = 'node',
    -- args = { mason_path .. '/packages/php-debug-adapter/extension/out/phpDebug.js' },
  }

  -- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
  dap.adapters['pwa-node'] = {
    -- type = 'executable',
    -- command = 'js-debug-adapter ${port}',
    type = 'server',
    -- host = 'localhost',
    host = '0.0.0.0',
    -- host = '127.0.0.1',
    -- host = '${address}',
    port = 9229,
    -- port = '{port}',
    executable = {
      command = 'js-debug-adapter',
      -- command = mason_path .. '/bin/js-debug-adapter',
      args = { "${port}" },
      -- command = "node",
      -- args = { mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }

  -- dap.adapters.node2 = {
  --   type = 'executable',
  --   command = 'node2-debug-adapter', -- this calls the same thing below
  --   -- command = 'node',
  --   -- args = { mason_path .. '/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  -- }
end

local adjust_dap_signs = function()
  -- vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'debugPC', linehl = 'debugPC', numhl = 'debugPC' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
  -- vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'debugBreakpoint', linehl = 'debugBreakpoint', numhl = 'debugBreakpoint' })
end

local clear_dap_virtual_text = function(_, _)
  local ok, virtual_text = pcall(require, 'nvim-dap-virtual-text.virtual_text')
  if not ok then return end
  virtual_text.clear_virtual_text()
end

local close_dap_ui = function()
  local ok, dapui = pcall(require, 'dapui')
  if not ok then return end
  dapui.close({ reset = true })
end

local register_event_listeners = function()
  require 'dap'.listeners.after['event_terminated']['clear_virtual_text'] = clear_dap_virtual_text
  require 'dap'.listeners.after['event_exited']['clear_virtual_text'] = clear_dap_virtual_text
  require 'dap'.listeners.after['disconnect']['clear_virtual_text'] = clear_dap_virtual_text
  -- require 'dap'.listeners.after['event_stopped']['clear_virtual_text'] = clear_dap_virtual_text

  require 'dap'.listeners.after['event_initialized']['open_dapui'] = function()
    local ok, dapui = pcall(require, 'dapui')
    if not ok then return end
    dapui.open()
  end
  require 'dap'.listeners.after['event_terminated']['close_dapui'] = close_dap_ui
  require 'dap'.listeners.after['event_exited']['close_dapui'] = close_dap_ui
  require 'dap'.listeners.after['disconnect']['close_dapui'] = close_dap_ui
end

lvim.builtin.dap.on_config_done = function()
  register_dap_adapters()
  adjust_dap_signs()
  register_event_listeners()
end

require 'saatchiart.plugin_configs'.configure_nvim_dap()

-- }}}

-- nvim-navic {{{
-- https://github.com/SmiteshP/nvim-navic#%EF%B8%8F-setup
vim.g.navic_silence = true
-- lvim.builtin.breadcrumbs.options.separator = ' ' .. lvim.icons.ui.ChevronShortRight .. ' ' -- bug: this is only used for the _second_ separator and beyond https://github.com/LunarVim/LunarVim/blob/ea9b648a52de652a972471083f1e1d67f03305fa/lua/lvim/core/breadcrumbs.lua#L160
-- }}}

-- nvim-tree {{{

-- https://github.com/nvim-tree/nvim-tree.lua/issues/674
lvim.builtin.nvimtree.hide_dotfiles = nil
lvim.builtin.nvimtree.ignore = nil
lvim.builtin.nvimtree.git = {
  enable = true,
  ignore = true,
}

lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.unstaged = lvim.icons.git.FileUnstaged
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.untracked = lvim.icons.git.FileUntracked
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.staged = lvim.icons.git.FileStaged

lvim.builtin.nvimtree.setup.disable_netrw = true
lvim.builtin.nvimtree.setup.hijack_netrw = true

-- match lsp icons
lvim.builtin.nvimtree.setup.diagnostics.icons = {
  error = lvim.icons.diagnostics.Error,
  hint = lvim.icons.diagnostics.Hint,
  info = lvim.icons.diagnostics.Information,
  warning = lvim.icons.diagnostics.Warning,
}

if not vim.tbl_contains(lvim.builtin.nvimtree.setup.filters.custom, '\\.git') then table.insert(lvim.builtin.nvimtree.setup.filters.custom, '\\.git') end
if not vim.tbl_contains(lvim.builtin.nvimtree.setup.filters.custom, '\\.null-ls*') then table.insert(lvim.builtin.nvimtree.setup.filters.custom, '\\.null-ls*') end
-- }}}

-- nvim-treesitter {{{
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { 'php' } -- needed to make non-treesitter indent work

vim.g.skip_ts_context_commentstring_module = true

lvim.builtin.treesitter.ensure_installed = {
  'comment',
  'lua', -- update to latest
  'luadoc',
  'jsdoc',
  'markdown_inline',
  'phpdoc',
  'regex', -- used by php-enhanced-treesitter
  'sql', -- used by php-enhanced-treesitter
  'vim', -- MUST update from the built-in or my config will cause problems when trying to display
}

lvim.builtin.treesitter.ignore_install = {
  'javascriptreact'
}

lvim.builtin.treesitter.context_commentstring.config.gitconfig = '# %s'
lvim.builtin.treesitter.context_commentstring.config.sql = '-- %s'
lvim.builtin.treesitter.context_commentstring.config.php = '// %s'

for _, filetype in pairs({
  'php',
  -- 'javascript',
  -- 'javascriptreact',
  -- 'typescript',
  -- 'typescriptreact',
}) do
  if not vim.tbl_contains(lvim.builtin.treesitter.indent.disable, filetype) then
    table.insert(lvim.builtin.treesitter.indent.disable, filetype)
  end
end

-- vim.api.nvim_create_augroup('incremental_selection_fix', { clear = true })
-- vim.api.nvim_create_autocmd('cmdwinenter', { pattern = '*', group = 'incremental_selection_fix',
--   command = 'TSBufDisable incremental_selection'
-- })

lvim.builtin.treesitter.auto_install = true
-- this breaks q:
-- lvim.builtin.treesitter.incremental_selection = {
--   enable = true,
--   keymaps = {
--     init_selection = '<cr>',
--     node_incremental = '<cr>',
--     scope_incremental = false,
--     node_decremental = '<bs>',
--   }
-- }

lvim.builtin.treesitter.on_config_done = function()
  -- fancy styled-components queries found on the web
  -- local are_treesitter_styled_components_found, treesitter_styled_components = pcall(require, 'mikedfunk.treesitter_styled_components')
  -- if not are_treesitter_styled_components_found then return end
  -- treesitter_styled_components.directives()
  -- treesitter_styled_components.queries()

  -- THIS BREAKS gg because the shortcuts are already defined in nvim_treesitter_textobjects
  -- if not is_installed('which-key') then return end
  -- require 'which-key'.register({
  --   ['>'] = { name = 'Swap Next' },
  --   ['<'] = { name = 'Swap Previous' },
  -- }, { prefix = 'g' })

  require 'nvim-treesitter.parsers'.get_parser_configs().blade = {
    install_info = {
      url = "https://github.com/EmranMR/tree-sitter-blade",
      files = {"src/parser.c"},
      branch = "main",
    },
    filetype = 'blade',
  }
end

-- }}}

-- project.nvim {{{
if not vim.tbl_contains(lvim.builtin.project.patterns, 'composer.json') then table.insert(lvim.builtin.project.patterns, 'composer.json') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'config.lua') then table.insert(lvim.builtin.project.patterns, 'config.lua') end
if not vim.tbl_contains(lvim.builtin.project.patterns, 'bootstrap') then table.insert(lvim.builtin.project.patterns, 'bootstrap') end
-- }}}

-- telescope.nvim {{{

lvim.builtin.telescope.defaults.prompt_prefix = ' ' .. lvim.icons.ui.Search .. ' ' -- ⌕ 
lvim.builtin.telescope.defaults.winblend = vim.o.winblend -- pseudo-transparency
lvim.builtin.telescope.defaults.mappings.i['<Esc>'] = lvim.builtin.telescope.defaults.mappings.i['<C-c>'] -- disable normal mode

lvim.builtin.telescope.defaults.preview = { timeout = 1500 } -- default is 250 :/

lvim.builtin.telescope.on_config_done = function()
  -- https://github.com/LunarVim/LunarVim/issues/2374#issuecomment-1079453881
  local actions = require 'telescope.actions'
  lvim.builtin.telescope.defaults.mappings.i['<CR>'] = actions.select_default

  ---@return nil
  local grep_string = function()
    local default = vim.api.nvim_eval([[expand("<cword>")]])
    vim.ui.input({
      prompt = 'Search for: ',
      default = default,
    }, function(input)
      require('telescope.builtin').grep_string({ search = input })
    end)
  end

  lvim.builtin.which_key.mappings.s['i'] = { grep_string, 'Text From Input' }

  -- default is git_files (only already tracked) if in a git project, I don't like that
  lvim.builtin.which_key.mappings['f'] = { function() require('telescope.builtin').find_files {} end, 'Find File' }

  -- flip these mappings - lunarvim defaults are counter-intuitive
  lvim.builtin.telescope.defaults.mappings.i['<C-n>'] = actions.cycle_history_next
  lvim.builtin.telescope.defaults.mappings.i['<C-p>'] = actions.cycle_history_prev

  lvim.builtin.telescope.defaults.mappings.i['<C-j>'] = actions.move_selection_next
  lvim.builtin.telescope.defaults.mappings.i['<C-k>'] = actions.move_selection_previous

  vim.api.nvim_create_augroup('telescope_no_cmp', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = 'telescope_no_cmp',
    pattern = 'TelescopePrompt',
    callback = function()
      require 'cmp'.setup.buffer { enabled = false }
    end
  })
end
-- }}}

-- toggle-term.nvim {{{
lvim.builtin.terminal.execs = { { 'tig status', '<Leader>gg', 'Tig', 'float' } }
-- }}}

-- tokyonight.nvim {{{

lvim.colorscheme = 'tokyonight'
lvim.builtin.lualine.options.theme = 'tokyonight'
lvim.builtin.theme.name = 'tokyonight'
-- lvim.builtin.theme.tokyonight.options.style = 'storm'
-- lvim.builtin.theme.tokyonight.options.style = 'moon'
lvim.builtin.theme.tokyonight.options.style = 'night'

lvim.builtin.theme.tokyonight.options.dim_inactive = true -- dim inactive windows
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- bold headers for each section header
lvim.builtin.theme.tokyonight.options.sidebars = { 'NvimTree', 'aerial', 'Outline', 'DapSidebar', 'UltestSummary', 'dap-repl' }
-- lvim.builtin.theme.tokyonight.options.day_brightness = 0.05 -- high contrast
lvim.builtin.theme.tokyonight.options.day_brightness = 0.15 -- high contrast but colorful
lvim.builtin.theme.tokyonight.options.lualine_bold = true -- section headers in lualine theme will be bold
lvim.builtin.theme.tokyonight.options.hide_inactive_statusline = true
-- vim.cmd 'silent! hi! link TabLineFill BufferLineGroupSeparator' -- temp workaround to bufferline background issue

lvim.builtin.theme.tokyonight.options.on_highlights = function(hl, c)
  local util = require 'tokyonight.util'
  hl.Folded = {
    -- change the fold color to be more subtle in both night and day modes
    -- yes, the bg was set to an fg color in tokyonight
    bg = util.darken(c.fg_gutter, 0.1),
  }
  hl.ColorColumn = {
    -- higher contrast since I am trying xiyaowong/virtcolumn.nvim
    bg = util.lighten(c.black, 1.05),
  }
end
-- }}}

-- which-key.nvim {{{
-- lvim.builtin.which_key.opts.nowait = false
-- lvim.builtin.which_key.vopts.nowait = false
lvim.builtin.which_key.setup.icons.group = ' '
lvim.builtin.which_key.setup.window.border = 'rounded'
lvim.builtin.which_key.setup.window.winblend = 15
-- see mappings for lvim.builtin.which_key.on_config_done

lvim.builtin.which_key.setup.plugins.marks = true
lvim.builtin.which_key.setup.plugins.registers = true

lvim.builtin.which_key.setup.plugins.presets.g = true
lvim.builtin.which_key.setup.plugins.presets.motions = true
lvim.builtin.which_key.setup.plugins.presets.nav = true
lvim.builtin.which_key.setup.plugins.presets.operators = true
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.setup.plugins.presets.windows = true
lvim.builtin.which_key.setup.plugins.presets.z = true

-- }}}

-- }}}

-- put file-based plugins in lvim.plugins {{{
local plugins = vim.api.nvim_get_runtime_file('lua/plugins/*', true)
lvim.plugins = {}

for _, plugin in pairs(plugins) do
  local path = string.gsub(plugin, "^.*/(plugins/[a-zA-Z0-9_-]+)%.lua", "%1")
  table.insert(lvim.plugins, require(path))
end
-- }}}
