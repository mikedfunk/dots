return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "folke/tokyonight.nvim" },
  opts = function(_, opts)
    local colors = require("tokyonight.colors").setup()

    local lsp_component = {
      -- remove null_ls from lsp clients, adjust formatting
      ---@param message string
      ---@return string
      function(message)
        local buf_clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
        if buf_clients and next(buf_clients) == nil then
          if type(message) == "boolean" or #message == 0 then
            return ""
          end
          return message
        end

        local buf_client_names = {}

        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
          end
        end

        buf_client_names = vim.fn.uniq(buf_client_names) ---@diagnostic disable-line missing-parameter

        -- no longer needed with full width statusbar
        -- if vim.fn.winwidth(0) < 150 and #(buf_client_names) > 1 then return #(buf_client_names) end

        local number_to_show = 1
        local first_few = vim.list_slice(buf_client_names, 1, number_to_show)
        local extra_count = #buf_client_names - number_to_show
        local output = table.concat(first_few, ", ")
        if extra_count > 0 then
          output = output .. " +" .. extra_count
        end
        return output
      end,
      icon = { "ʪ", color = { fg = colors.blue } },
      color = { gui = "None" },
      on_click = function()
        vim.cmd("LspInfo")
      end,
    }

    local conform_nvim_component = {
      ---@return string
      function()
        local formatters = require("conform").formatters_by_ft[vim.bo.ft] or {}

        local number_to_show = 1
        local first_few = vim.list_slice(formatters --[=[@as string[]]=], 1, number_to_show)
        local extra_count = #formatters - number_to_show
        local output = table.concat(first_few, ", ")
        if extra_count > 0 then
          output = output .. " +" .. extra_count
        end
        return output
      end,
      color = {
        gui = "None",
      },
      icon = { "", color = { fg = colors.purple } },
      cond = function()
        -- local ok, _ = pcall(require, "conform")
        -- return ok ~= nil
        return package.loaded["conform"] ~= nil
      end,
    }

    local nvim_lint_component = {
      ---@return string
      function()
        local linters = require("lint").linters_by_ft[vim.bo.ft] or {}

        local number_to_show = 1
        local first_few = vim.list_slice(linters, 1, number_to_show)
        local extra_count = #linters - number_to_show
        local output = table.concat(first_few, ", ")
        if extra_count > 0 then
          output = output .. " +" .. extra_count
        end
        return output
      end,
      color = {
        gui = "None",
      },
      icon = { "", color = { fg = colors.purple } },
      cond = function()
        return package.loaded["lint"] ~= nil
      end,
    }

    local codeium_status_component = {
      ---@return string
      function(_)
        return ""
      end,
      separator = { right = "" },
      color = function()
        local is_codeium_enabled = vim.fn.exists("*codeium#Enabled") == 1 and vim.fn["codeium#Enabled"]()

        return {
          fg = is_codeium_enabled and colors.green or colors.red,
        }
      end,
      -- cond = function()
      --   local success, _ = pcall(vim.cmd, 'Codeium')
      --   return success
      -- end,
      on_click = function()
        if vim.fn.exists("*codeium#Enabled") == 0 then
          return
        end

        if vim.fn["codeium#Enabled"]() then
          vim.cmd("CodeiumDisable")
        else
          vim.cmd("CodeiumEnable")
        end
      end,
    }

    -- TODO: this causes insert mode for some reason: vim.fn["codeium#GetStatusString"]()
    -- local codeium_component = {
    --   ---@return string
    --   function()
    --     local response = vim.fn["codeium#GetStatusString"]()
    --     response = vim.trim(response)
    --     if response == "ON" or response == "OFF" then
    --       return ""
    --     end
    --     return response
    --   end,
    --   padding = { left = 0, right = 1 },
    --   cond = function()
    --     return vim.fn.exists("*codeium#GetStatusString") == 1
    --   end,
    -- }

    local navic_component = {
      function()
        return require("nvim-navic").get_location()
      end,
      cond = function()
        return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
      end,
    }

    -- lualine builtin is not working for some reason
    local search_count_component = {
      function()
        if vim.v.hlsearch == 0 then
          return ""
        end

        local result = vim.fn.searchcount({ maxcount = 999, timeout = 500 })
        local denominator = math.min(result.total, result.maxcount)
        return string.format("[%d/%d]", result.current, denominator)
      end,
      { icon = { "" } },
    }

    local macro_component = {
      function()
        if vim.fn.reg_recording() == "" then
          return ""
        end
        return "Recording: " .. vim.fn.reg_recording()
      end,
      icon = { "", color = { fg = colors.red, gui = "Bold" } },
      cond = function()
        return vim.fn.reg_recording() ~= ""
      end,
    }

    local current_session_component = {
      function()
        local session_name, _ = vim.v.this_session:gsub("^(.*/)(.*)$", "%2")
        return session_name
      end,
      cond = function()
        return vim.v.this_session ~= nil
      end,
      icon = { "", color = { fg = colors.cyan } },
    }

    ---@return string
    local dap_component = {
      function()
        local is_dap_installed, dap = pcall(require, "dap")
        if is_dap_installed then
          return dap.status()
        else
          return ""
        end
      end,
      icon = { "", color = { fg = colors.yellow } },
      cond = function()
        local is_dap_installed, dap = pcall(require, "dap")
        return is_dap_installed and dap.status ~= ""
      end,
    }

    opts.sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
        navic_component,
      },
      lualine_x = {
        macro_component,
        search_count_component,
        dap_component,
        current_session_component,
        {
          "diagnostics",
          symbols = {
            error = require("lazyvim.config").icons.diagnostics.Error,
            warn = require("lazyvim.config").icons.diagnostics.Warn,
            info = require("lazyvim.config").icons.diagnostics.Info,
            hint = require("lazyvim.config").icons.diagnostics.Hint,
          },
          -- on_click = function()
          --   vim.cmd("Telescope diagnostics bufnr=0 theme=get_ivy")
          -- end,
        },
        lsp_component,
        nvim_lint_component,
        conform_nvim_component,
        codeium_status_component,
        -- codeium_component,
      },
    }
  end,
}
