-- CI Checks component
local github_actions_failure_checks_count = 0
local mason_updates_count = 0

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "mfussenegger/nvim-lint",
      -- "monkoose/neocodeium",
      "stevearc/conform.nvim",
    },
    opts = function(_, opts)
      opts.options.disabled_filetypes.winbar = {
        "Avante",
        "AvanteInput",
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "cmp",
        "dashboard",
        "lazy",
        "lspinfo",
        "mason",
        "snacks_dashboard",
        "snacks_picker_input",
        "starter",
      }

      opts.options.disabled_filetypes.statusline = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "lazy",
        "lspinfo",
        "mason",
        "snacks_dashboard",
        "snacks_picker_input",
        "starter",
      }

      opts.sections.lualine_y = {
        { "progress" },
      }

      opts.sections.lualine_z = {
        { "location" },
      }

      -- mason updates {{{

      local registry_ok, registry = pcall(require, "mason-registry")
      local function get_mason_updates_count()
        if not registry_ok then
          return 0
        end

        local pkgs = registry.get_installed_packages()
        local count = 0

        for _, pkg in ipairs(pkgs) do
          local ok_installed, installed = pcall(function()
            return pkg:get_installed_version()
          end)
          local ok_latest, latest = pcall(function()
            return pkg:get_latest_version()
          end)
          if ok_installed and ok_latest and installed and latest and installed ~= latest then
            count = count + 1
          end
        end

        return count
      end

      -- run this once at startup
      -- if registry_ok then
      --   registry.refresh(function()
      --     mason_updates_count = get_mason_updates_count()
      --   end)
      -- end

      -- refresh the registry and update the count every 10 minutes (600,000 ms)
      local mason_updates_timer = vim.loop.new_timer()
      local cache_time_in_milliseconds = 600000
      mason_updates_timer:start(
        cache_time_in_milliseconds, -- first run delay
        cache_time_in_milliseconds, -- repeat interval
        vim.schedule_wrap(function()
          if registry_ok then
            registry.refresh(function()
              mason_updates_count = get_mason_updates_count()
            end)
          end
        end)
      )

      local mason_updates_component = {
        function()
          return mason_updates_count > 0 and ("⚒ " .. mason_updates_count) or ""
        end,
        color = function()
          return {
            fg = Snacks.util.color("Character"),
            gui = "None",
          }
        end,
        cond = function()
          return mason_updates_count > 0
        end,
        on_click = function()
          vim.cmd("Mason")
        end,
      }

      table.insert(opts.sections.lualine_x, mason_updates_component)
      -- }}}
      --
      -- github checks {{{

      local function update_ci_checks()
        vim.fn.jobstart("gh pr checks --json state 2>/dev/null", {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if not data then
              return
            end
            local output = table.concat(data, "")
            local ok, json = pcall(vim.json.decode, output)
            if ok and type(json) == "table" then
              github_actions_failure_checks_count = 0
              for _, check in ipairs(json) do
                if check.state == "FAILURE" or check.state == "ERROR" then
                  github_actions_failure_checks_count = github_actions_failure_checks_count + 1
                end
              end
            else
              -- Invalid JSON or no PR - reset to 0
              github_actions_failure_checks_count = 0
            end
          end,
          on_exit = function(_, exit_code)
            -- If gh command fails (no PR, no remote branch, etc), reset
            if exit_code ~= 0 then
              github_actions_failure_checks_count = 0
            end
          end,
        })
      end

      -- Update every 2 minutes (120,000 ms)
      local ci_timer = vim.loop.new_timer()
      ci_timer:start(5000, 120000, vim.schedule_wrap(update_ci_checks))

      local ci_checks_component = {
        function()
          if github_actions_failure_checks_count == 0 then
            return ""
          end
          return " " .. github_actions_failure_checks_count
        end,
        color = function()
          return { fg = Snacks.util.color("DiagnosticError") }
        end,
        cond = function()
          return github_actions_failure_checks_count > 0
        end,
        on_click = function()
          vim.cmd("terminal gh pr checks")
        end,
      }

      table.insert(opts.sections.lualine_c, 2, ci_checks_component)
      -- }}}

      -- neocodeium {{{
      local neocodeium_status_component = {
        function()
          return LazyVim.config.icons.kinds.Codeium:gsub("%s+", "")
        end,
        color = function()
          local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
          return {
            fg = is_neocodeium_enabled and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
          }
        end,
        on_click = function()
          if package.loaded["neocodeium"] then
            vim.cmd("NeoCodeium toggle")
          end
        end,
        cond = function()
          return package.loaded["neocodeium"] ~= nil
        end,
      }

      table.insert(opts.sections.lualine_x, neocodeium_status_component)
      -- }}}

      -- minuet-ai {{{
      -- if package.loaded["minuet"] then
      --   table.insert(opts.sections.lualine_x, require("minuet.lualine"))
      -- end
      -- }}}

      -- nvim-lint and ale linters {{{
      ---@return string[]
      local function get_linters()
        local linters = { unpack(require("lint").linters_by_ft[vim.bo.ft] or {}) }
        for _, linter in ipairs(vim.g.ale_linters and vim.g.ale_linters[vim.bo.ft] or {}) do
          if not vim.tbl_contains(linters, linter) then
            table.insert(linters, linter)
          end
        end

        return linters
      end

      local nvim_lint_component = {
        ---@return string
        function()
          return " " .. tostring(#get_linters())
        end,
        color = function()
          return {
            fg = #get_linters() > 0 and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
            gui = "None",
          }
        end,
        cond = function()
          return package.loaded["lint"] ~= nil
        end,
        on_click = function()
          print(vim.inspect(get_linters()))
        end,
      }

      table.insert(opts.sections.lualine_x, nvim_lint_component)
      -- }}}

      -- conform.nvim and ale fixers {{{
      ---@return string[]
      local function get_formatters()
        local raw_enabled_formatters, _ = require("conform").list_formatters_to_run()
        ---@type string[]
        local formatters = {}

        for _, formatter in ipairs(raw_enabled_formatters) do
          table.insert(formatters, formatter.name)
        end

        ---@type string[]
        local ale_fixers = vim.g.ale_fixers and vim.g.ale_fixers[vim.bo.ft] or {}

        for _, formatter in ipairs(ale_fixers) do
          if not vim.tbl_contains(formatters, formatter) then
            table.insert(formatters, formatter)
          end
        end

        return formatters
      end

      local conform_nvim_component = {
        ---@return string
        function()
          return " " .. tostring(#get_formatters())
        end,
        color = function()
          return {
            fg = #get_formatters() > 0 and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
            gui = "None",
          }
        end,
        cond = function()
          return package.loaded["conform"] ~= nil
        end,
        on_click = function()
          vim.cmd("LazyFormatInfo")
        end,
      }

      table.insert(opts.sections.lualine_x, conform_nvim_component)
      -- }}}

      -- lsp clients {{{
      local get_lsp_client_names = function()
        local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

        ---@type string[]
        local buf_client_names = {}

        for _, client in pairs(buf_clients) do
          table.insert(buf_client_names, client.name)
        end

        ---@type string[]
        buf_client_names = vim.fn.uniq(buf_client_names) ---@diagnostic disable-line missing-parameter
        return buf_client_names
      end

      local lsp_status_component = {
        ---@return string
        function()
          return "ʪ " .. tostring(#get_lsp_client_names())
        end,
        color = function()
          return {
            fg = #get_lsp_client_names() > 0 and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
            gui = "None",
          }
        end,
        on_click = function()
          vim.cmd("LspInfo")
        end,
      }

      table.insert(opts.sections.lualine_x, lsp_status_component)
      -- }}}
    end,
  },
}
