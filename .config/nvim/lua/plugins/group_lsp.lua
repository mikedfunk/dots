return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      -- vim.lsp.start({
      --   name = "contextive",
      --   cmd = { "Contextive.LanguageServer" },
      --   root_dir = vim.fs.dirname(vim.fs.find({ ".contextive" }, { upward = true })[1]),
      -- })
      -- vim.lsp.start({
      --   name = "semgrep",
      --   cmd = { "semgrep", "lsp" },
      --   root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
      -- })

      opts.servers = vim.tbl_deep_extend("force", opts.servers, {
        cssls = {},
        -- cucumber_language_server = {}, -- https://github.com/tree-sitter/tree-sitter-typescript/issues/244
        docker_compose_language_service = {},
        -- NOTE: eslint is handled by a lazyvim extra in ../config/lazy.lua
        dockerls = {},
        flow = {},
        jsonls = {},
        lemminx = {},
        -- nginx_language_server = {},
        phpactor = { enabled = false },
        ruff_lsp = {},
        -- snyk_ls = {
        --   init_options = {
        --     token = os.getenv("SNYK_TOKEN"),
        --     enableTrustedFoldersFeature = "false",
        --     enableTelemetry = "false",
        --     activateSnykCodeQuality = "true",
        --     organization = "leaf-saatchiart",
        --     -- automaticAuthentication = "false",
        --     -- authenticationMethod = "token",
        --   },
        -- },
        sqlls = {},
        tailwindcss = {
          root_dir = require("lspconfig.util").root_pattern("tailwind.config.js"),
        },
        taplo = {},
        tsserver = {
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json"),
          single_file_support = false,
        },
        yamlls = {},
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    ---@class ConformOpts
    opts = {
      format = {
        timeout_ms = 20000,
      },
      ---@type table<string, conform.FormatterUnit[]>
      formatters_by_ft = {
        -- NOTE: prettier is handled by a lazyvim extra in ../config/lazy.lua
        blade = { "blade-formatter", "rustywind" },
        javascript = { "prettier", "rustywind" }, -- prettier wasn't included for javascript in the lazyvim extra :/
        markdown = { "cbfmt" },
        php = { "phpcbf", "php_cs_fixer" },
        python = { "black" },
        sql = { "sqlfluff" },
        typescript = { "rustywind" },
        typescriptreact = { "rustywind" },
      },
      formatters = {
        phpcbf = {
          prepend_args = {
            "--cache",
            "--warning-severity=3",
            "-d",
            "memory_limit=100M",
            "-d",
            "xdebug.mode=off",
          },
        },
        php_cs_fixer = {
          condition = function(ctx)
            return vim.fs.find({ ".php-cs-fixer.php" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        sqlfluff = {
          prepend_args = {
            "--dialect",
            "mysql",
          },
        },
      },
    },
  },
  {

    "mfussenegger/nvim-lint",
    ---@type table<string,table>
    opts = {
      linters_by_ft = {
        editorconfig = { "editorconfig-checker" },
        gitcommit = { "gitlint" },
        javascript = { "cspell" },
        make = { "checkmake" },
        php = { "phpstan", "phpcs", "cspell" },
        python = { "isort" },
        sql = { "sqlfluff" },
      },
      linters = {
        phpstan = {
          "--memory-limit=200M",
          "--level=9",
        },
        phpcs = {
          -- This doesn't work because the parser expects stdin :/
          -- stdin = false,
          args = {
            "-q",
            "--report=json",
            "--cache",
            "--warning-severity=3",
            "-d",
            "memory_limit=100M",
            "-d",
            "xdebug.mode=off",
            "-",
          },
        },
      },
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = {
        enabled = true,
      },
      sign = {
        text = "",
        hl = "DiagnosticSignWarn",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
      ensure_installed = {
        -- "actionlint",
        "black",
        "blade-formatter",
        "cbfmt",
        "checkmake",
        "css-lsp",
        "cspell",
        -- "contextive",
        -- "cucumber-language-server", -- https://github.com/tree-sitter/tree-sitter-typescript/issues/244
        "docker-compose-language-service",
        "dockerfile-language-server",
        "editorconfig-checker",
        "gitlint",
        "isort",
        "json-lsp",
        "lemminx",
        -- "nginx-language-server",
        "php-cs-fixer",
        "ruff-lsp",
        "rustywind",
        -- "snyk-ls",
        "sqlfluff",
        "sqlls",
        "tailwindcss-language-server",
        "taplo",
        "yaml-language-server",
      },
    },
  },
  -- TODO: not working
  -- {
  --   "nvimtools/none-ls.nvim",
  --   dependencies = { "mason.nvim", "davidmh/cspell.nvim" },
  --   opts = function(_, opts)
  --     opts.sources = vim.list_extend(opts.sources or {}, {
  --       require("cspell").code_actions,
  --     })
  --   end,
  -- },
}
