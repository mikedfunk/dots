local is_installed = require 'helpers'.is_installed

lvim.builtin.lualine.active = true
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

return {}
