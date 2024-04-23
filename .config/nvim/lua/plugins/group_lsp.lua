return {
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
        biome = {}, -- https://github.com/biomejs/biome/discussions/87#discussioncomment-6891432
        cssls = {},
        -- cucumber_language_server = {}, -- https://github.com/tree-sitter/tree-sitter-typescript/issues/244
        docker_compose_language_service = {},
        -- NOTE: eslint is handled by a lazyvim extra in ../config/lazy.lua
        dockerls = {},
        flow = {
          cmd = vim.fn.filereadable("./node_modules/.bin/flow") == 1 and { "npm", "exec", "flow", "lsp" }
            or { "npx", "flow", "lsp" },
        },
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
        --   },
        -- },
        sqlls = {},
        tailwindcss = {
          -- https://www.reddit.com/r/neovim/comments/1c784zq/tailwindcss_unusable_inotify_max_events_does/l068l30/
          -- capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = false } } },
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
    opts = function(_, opts)
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      opts.format = vim.tbl_deep_extend("force", opts.format, {
        timeout_ms = 20000,
      })

      -- what a pain in the ass. If I don't use list_extend here, it will
      -- _override_ the previous list, not append to it. This list was already
      -- added to by extras.prettier.
      opts.formatters_by_ft.blade =
        vim.list_extend(opts.formatters_by_ft.blade or {}, { "blade-formatter", "rustywind" })
      opts.formatters_by_ft.javascript = vim.list_extend(opts.formatters_by_ft.javascript or {}, { "rustywind" })
      opts.formatters_by_ft.javascriptreact =
        vim.list_extend(opts.formatters_by_ft.javascriptreact or {}, { "rustywind" })
      opts.formatters_by_ft.php = vim.list_extend(opts.formatters_by_ft.php or {}, { "phpcbf", "php_cs_fixer" })
      opts.formatters_by_ft.python = vim.list_extend(opts.formatters_by_ft.python or {}, { "black" })
      opts.formatters_by_ft.sql = vim.list_extend(opts.formatters_by_ft.sql or {}, { "sqlfluff" })
      opts.formatters_by_ft.svelte = vim.list_extend(opts.formatters_by_ft.svelte or {}, { "rustywind" })
      opts.formatters_by_ft.typescript = vim.list_extend(opts.formatters_by_ft.typescript or {}, { "rustywind" })
      opts.formatters_by_ft.typescriptreact =
        vim.list_extend(opts.formatters_by_ft.typescriptreact or {}, { "rustywind" })
      opts.formatters_by_ft.vue = vim.list_extend(opts.formatters_by_ft.vue or {}, { "rustywind" })

      ---@type table<string, conform.FormatterUnit[]>
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters, {
        phpcbf = {
          prepend_args = {
            "--cache",
            "--warning-severity=3",
            "-d",
            "memory_limit=100m",
            "-d",
            "xdebug.mode=off",
          },
        },
        php_cs_fixer = {
          cwd = require("conform.util").root_file({ ".php-cs-fixer.php" }),
          require_cwd = true,
        },
        prettier = {
          cwd = require("conform.util").root_file({
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
          }),
          require_cwd = true,
        },
        sqlfluff = {
          prepend_args = { "--dialect", "mysql" },
        },
      })
    end,
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
        "biome",
        -- "cbfmt",
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
        "markdownlint",
        -- "nginx-language-server",
        "php-cs-fixer",
        "prettierd",
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
  { "antosha417/nvim-lsp-file-operations", config = true },
}
