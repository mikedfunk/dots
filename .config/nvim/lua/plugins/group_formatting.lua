return {
  -- TODO: I can't get this to work. It can't find any mason packages. I'll
  -- have to add these in mason ensure_installed instead. I'm setting
  -- everything up to run in the order it requires. 🤷 last checked 2024-09-21
  -- {
  --   "LittleEndianRoot/mason-conform",
  --   dependencies = {
  --     "stevearc/conform.nvim",
  --     dependencies = "williamboman/mason.nvim",
  --   },
  --   opts = {},
  -- },
  {
    -- add some lualine components to display some more things in the statusline
    "nvim-lualine/lualine.nvim",
    ---Add some lualine components
    ---@class LuaLineOpts
    ---@field sections table
    ---@param opts LuaLineOpts
    opts = function(_, opts)
      ---@return string[]
      local function get_formatters()
        ---@class OneFormatter
        ---@field name string
        ---@type OneFormatter[]
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
            fg = #get_formatters() > 0 and LazyVim.ui.fg("Normal").fg or LazyVim.ui.fg("Comment").fg,
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
    end,
  },
  {
    "stevearc/conform.nvim",
    -- NOTE: workaround: see above comment about mason-conform which I would rather use
    -- dependencies = {
    --   "williamboman/mason.nvim",
    --   opts_extend = { "ensure_installed" },
    --   opts = {
    --     ensure_installed = {
    --       "black", -- moved to lazy extra
    --     },
    --   },
    -- },
    opts_extend = {
      -- "formatters_by_ft.python",
      "formatters_by_ft.php",
      "formatters.phpcbf.prepend_args",
    },
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        timeout_ms = 30000,
        async = true,
      },
      formatters_by_ft = {
        -- python = { "black" }, -- moved to lazy extra
        php = { "rector", "phpcbf", "php_cs_fixer" },
      },
      formatters = {
        rector = function()
          local util = require("conform.util")
          ---@type conform.FormatterConfigOverride
          return {
            meta = {
              url = "https://github.com/rectorphp/rector",
              description = "Instant Upgrades and Automated Refactoring",
            },
            command = util.find_executable({
              "tools/rector/vendor/bin/rector",
              "vendor/bin/rector",
            }, "rector"),
            args = { "process", "$FILENAME" },
            stdin = false,
            cwd = util.root_file({ "composer.json" }),
          }
        end,
        phpcbf = {
          -- ALWAYS use local version because it is tightly coupled to the
          -- default _rules_ it comes with.
          command = "./vendor/bin/phpcbf",
          prepend_args = {
            "--cache",
            "--warning-severity=3", -- fix warnings from severity 3 up to the max of 5
            -- "--warning-severity=0", -- do not fix warnings, same as -n
            "-d",
            "memory_limit=100m",
            "-d",
            "xdebug.mode=off",
            "-d",
            "zend.enable_gc=0",
          },
        },
        php_cs_fixer = {
          -- command = "php -d zend.enable_gc=0 -d xdebug.mode=off -d memory_limit=100m php-cs-fixer",
          cwd = function(self, ctx)
            return require("conform.util").root_file({ ".php-cs-fixer.php" })(self, ctx)
          end,
          require_cwd = true,
        },
        prettier = {
          command = "prettier",
          cwd = function(self, ctx)
            return require("conform.util").root_file({
              -- O_O
              ".prettierrc",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.json",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.mjs",
              ".prettierrc.cjs",
              "prettier.config.js",
              "prettier.config.mjs",
              "prettier.config.cjs",
              ".prettierrc.toml",
            })(self, ctx)
          end,
          require_cwd = true,
        },
        stylua = {
          require_cwd = true,
        },
      },
    },
  },
}
