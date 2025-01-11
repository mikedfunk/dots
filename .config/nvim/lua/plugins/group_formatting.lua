return {
  {
    "stevearc/conform.nvim",
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
          -- command = function(self, ctx)
          --   local executable = require("conform.util").find_executable({
          --     "tools/php-cs-fixer/vendor/bin/php-cs-fixer",
          --     "vendor/bin/php-cs-fixer",
          --   }, "php-cs-fixer")(self, ctx)
          --
          --   -- temporary hack until PHP 8.4 is officially supported
          --   return "PHP_CS_FIXER_IGNORE_ENV=1" .. " " .. executable
          -- end,
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
