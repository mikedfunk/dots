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

      -- NOTE: This is only needed if you need to change options or you are
      -- using a local version of a language server. If it's installed with
      -- Mason, ensure_installed below is enough.
      -- NOTE: eslint is handled by a lazyvim extra in ../config/lazy.lua
      opts.servers = vim.tbl_deep_extend("force", opts.servers, {
        flow = {
          cmd = vim.fn.filereadable("./node_modules/.bin/flow") == 1 and { "npm", "exec", "flow", "lsp" }
            or { "npx", "flow", "lsp" },
          filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
        },
        phpactor = { enabled = false },
        -- snyk_ls = {
        --   init_options = {
        --     token = os.getenv("SNYK_TOKEN"),
        --     enableTrustedFoldersFeature = "false",
        --     enableTelemetry = "false",
        --     activateSnykCodeQuality = "true",
        --     organization = "leaf-saatchiart",
        --   },
        -- },
        tailwindcss = {
          -- https://www.reddit.com/r/neovim/comments/1c784zq/tailwindcss_unusable_inotify_max_events_does/l068l30/
          -- capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = false } } },
          root_dir = require("lspconfig.util").root_pattern("tailwind.config.js"),
        },
        tsserver = {
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json"),
          single_file_support = false,
        },
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
    -- dependencies = {
    --   { "zapling/mason-lock.nvim", config = true }, -- doesn't work - error
    -- },
    opts = {
      ui = {
        border = "rounded",
      },
      ensure_installed = {
        "biome",
        "black",
        "blade-formatter",
        "checkmake",
        "cspell",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "editorconfig-checker",
        "emmet-language-server",
        "gitlint",
        "harper-ls", -- TODO: not in nvim-lspconfig yet
        "isort",
        "json-lsp",
        "lemminx",
        "markdownlint",
        "php-cs-fixer",
        "prettierd",
        "ruff-lsp",
        "rustywind",
        "sqlfluff",
        "sqlls",
        "tailwindcss-language-server",
        "taplo",
        "yaml-language-server",
        -- "actionlint",
        -- "cbfmt",
        -- "contextive",
        -- "cucumber-language-server", -- https://github.com/tree-sitter/tree-sitter-typescript/issues/244
        -- "nginx-language-server",
        -- "snyk-ls",
      },
    },
  },
  { "antosha417/nvim-lsp-file-operations", config = true },
  -- { "Wansmer/symbol-usage.nvim", event = "LspAttach", opts = { vt_position = "end_of_line" } }, -- buggy - breaks on dropbar
}
