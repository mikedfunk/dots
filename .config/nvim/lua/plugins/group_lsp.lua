return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      codelens = { enabled = true },
      servers = {
        biome = {},
        -- contextive = {
        --   root_dir = require("lspconfig.util").root_pattern(".contextive"),
        -- },
        cssls = {
          filetypes = { "css" },
        },
        cssmodules_ls = {},
        cucumber_language_server = {},
        flow = {},
        emmet_language_server = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript", -- added
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        },
        jsonls = {},
        lemminx = {},
        -- lsp_ai = {}, -- TODO: This is currently installed via cargo. Put this in Mason once it's available there.
        -- snyk_ls = {
        --   init_options = {
        --     token = os.getenv("SNYK_TOKEN"),
        --     enableTrustedFoldersFeature = "false",
        --     enableTelemetry = "false",
        --     activateSnykCodeQuality = "true",
        --     organization = "leaf-saatchiart",
        --   },
        -- },
        -- phpactor = {},
        somesass_ls = {},
        sqlls = {},
        tailwindcss = {
          root_dir = function(startpath)
            return require("lspconfig.util").root_pattern(
              "tailwind.config.js",
              "tailwind.config.cjs",
              "tailwind.config.mjs",
              "tailwind.config.ts",
              "tailwind.config.cts",
              "tailwind.config.mts"
            )(startpath)
          end,
        },
        taplo = {},
        vtsls = {
          root_dir = function(startpath)
            return require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json")(startpath)
          end,
          single_file_support = false,
        },
        yamlls = {},
        -- zk = {},
      },
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    opts = {
      autocmd = { enabled = true },
      sign = {
        text = "",
        hl = "DiagnosticSignWarn",
      },
    },
  },
  {
    -- "zapling/mason-lock.nvim",
    "mikedfunk/mason-lock.nvim",
    config = true,
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },
  { "antosha417/nvim-lsp-file-operations", config = true },
  -- Buggy and slow when lots of usages. Breaks on dropbar.
  -- Overlaps with LSP codelens references
  -- {
  --   "Wansmer/symbol-usage.nvim",
  --   enabled = false,
  --   event = "LspAttach",
  --   opts = { vt_position = "end_of_line" },
  -- },
  {
    "gbprod/phpactor.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      {
        "williamboman/mason.nvim",
        opts_extend = { "ensure_installed" },
        opts = {
          ensure_installed = { "phpactor" },
        },
      },
    },
    filetypes = { "php" },
    keys = {
      { "<Leader>rm", "<Cmd>PhpActor context_menu<CR>", buffer = true, noremap = true, desc = "PHP Refactor Menu" },
    },
    cmd = { "PhpActor" },
    opts = {
      install = {
        bin = vim.fn.stdpath("data") .. "/mason/packages/phpactor/phpactor.phar",
        php_bin = table.concat(vim.fn.systemlist({ "asdf", "where", "php", "8.2.12" }), "") .. "/bin/php",
        path = vim.fn.stdpath("data") .. "/mason/packages/phpactor",
        composer_bin = table.concat(vim.fn.systemlist({ "asdf", "where", "php", "8.2.12" }), "")
          .. "/.composer/vendor/bin/composer",
      },
      lspconfig = { enabled = false },
    },
  },
}
