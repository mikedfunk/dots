-- vim: set fdm=marker:
return {
  {
    -- automatically install nvim-lint packages that are configured
    "rshkarin/mason-nvim-lint",
    -- enabled = false,
    opts = function()
      -- add some missing packages :/
      require("mason-nvim-lint.mapping").nvimlint_to_package =
        vim.tbl_deep_extend("force", require("mason-nvim-lint.mapping").nvimlint_to_package, {
          checkmake = "checkmake",
          ["editorconfig-checker"] = "editorconfig-checker",
          ["markdownlint-cli2"] = "markdownlint-cli2",
          gitlint = "gitlint",
        })
    end,
    dependencies = {
      "mfussenegger/nvim-lint",
      "mason-org/mason.nvim",
    },
  },
  {
    "mfussenegger/nvim-lint",
    config = function(_, opts)
      -- fix phpcs linter to allow --stdin-path=... {{{
      require("lint.linters.phpcs").parser = function(output, _)
        local severities = {
          ERROR = vim.diagnostic.severity.ERROR,
          WARNING = vim.diagnostic.severity.WARN,
        }
        local bin = "phpcs"

        if vim.trim(output) == "" or output == nil then
          return {}
        end

        if not vim.startswith(output, "{") then
          -- vim.notify(output)
          return {}
        end

        local decoded = vim.json.decode(output)
        local diagnostics = {}
        -- the fix: {{{
        -- local messages = decoded['files']['STDIN']['messages']
        local messages = {}

        for _, values in pairs(decoded["files"]) do
          messages = values["messages"]
          break
        end
        -- }}}

        for _, msg in ipairs(messages or {}) do
          table.insert(diagnostics, {
            lnum = msg.line - 1,
            end_lnum = msg.line - 1,
            col = msg.column - 1,
            end_col = msg.column - 1,
            message = msg.message,
            code = msg.source,
            source = bin,
            severity = assert(severities[msg.type], "missing mapping for severity " .. msg.type),
          })
        end

        return diagnostics
      end
      -- }}}

      local lazyvim_config = require("lazyvim.plugins.linting")[1].config
      lazyvim_config(_, opts)
    end,
    opts_extend = {
      "linters_by_ft.editorconfig",
      "linters_by_ft.gitcommit",
      "linters_by_ft.javascript",
      "linters_by_ft.javascriptreact",
      "linters_by_ft.typescript",
      "linters_by_ft.typescriptreact",
      "linters_by_ft.markdown",
      "linters_by_ft.make",
      "linters_by_ft.php",
      "linters_by_ft.sql",
    },
    opts = {
      linters_by_ft = {
        fish = {}, -- BUGFIX: There is no such nvim-lint linter as "fish"
        editorconfig = { "editorconfig-checker" },
        gitcommit = { "gitlint" },
        javascript = { "cspell" },
        javascriptreact = { "cspell" },
        typescript = { "cspell" },
        typescriptreact = { "cspell" },
        markdown = { "markdownlint" },
        make = { "checkmake" },
        php = { "cspell" },
        -- sql = { "sqlruff" },
        -- php = { "cspell", "phpstan" }, -- see below - moved phpstan to ALE for now to avoid blocking the UI on save
      },
      linters = {
        -- phpstan is file-based and cannot be read from stdin, so it is not
        -- only slow (on level 9), it blocks the neovim UI while nvim-lint
        -- ("the async linter") is running it. My shitty workaround for now is
        -- to use ALE instead for PHPStan ONLY.
        -- phpstan = {
        --   cmd = "phpstan",
        --   args = {
        --     "analyze",
        --     "--error-format=json",
        --     "--no-progress",
        --     "--memory-limit=200M",
        --     "--level=9",
        --   },
        -- },
        phpcs = {
          args = {
            -- works together with stdin-path fix above
            function()
              return "--stdin-path=" .. vim.fn.expand("%")
            end,
            -- https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/phpcs.lua
            "-q",
            "--report=json",
            "--cache",
            -- "--warning-severity=3", -- show warnings from severity 3 up to the max of 5
            -- "--warning-severity=0", -- do not show warnings, same as -n
            "-d",
            "memory_limit=100M",
            "-d",
            "xdebug.mode=off",
            "-d",
            "zend.enable_gc=0",
            "-",
          },
        },
      },
    },
  },
  {
    -- this is ONLY for slow phpstan level 9. See comment above.
    "dense-analysis/ale",
    branch = "neovim-lsp-api",
    ft = { "php" },
    init = function()
      vim.g.ale_set_loclist = 0
      -- TODO: there is some problem with vim LSP diagnostic signs sent from ALE. I get everything else but signs.
      vim.g.ale_set_signs = 0
      vim.g.ale_echo_cursor = 0
      vim.g.ale_disable_lsp = 1
      vim.g.ale_hover_cursor = 0

      vim.g.ale_lint_delay = 0
      vim.g.ale_linters_explicit = 1

      vim.g.ale_linters = { php = { "phpstan" } }
      vim.g.ale_php_phpstan_level = 9
      vim.g.ale_php_phpstan_memory_limit = "300M"
      -- use latest version from Mason
      vim.g.ale_php_phpstan_use_global = 1

      -- vim.g.ale_fixers = { php = {"php_cs_fixer", "phpcbf" } }
      -- vim.g.ale_php_phpcbf_options = "--warning-severity=3"
    end,
  },
}
