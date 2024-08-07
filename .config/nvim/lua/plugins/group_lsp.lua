return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        biome = {},
        -- contextive = {
        --   root_dir = require("lspconfig.util").root_pattern(".contextive"),
        -- },
        cssls = {},
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
          root_dir = function(pattern)
            return require("lspconfig.util").root_pattern("tailwind.config.js")(pattern)
          end,
        },
        taplo = {},
        vtsls = {
          root_dir = function(pattern)
            return require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json")(pattern)
          end,
          single_file_support = false,
        },
        yamlls = {},
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
  -- { "Wansmer/symbol-usage.nvim", event = "LspAttach", opts = { vt_position = "end_of_line" } },
}
