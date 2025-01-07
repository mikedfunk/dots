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
    "zapling/mason-lock.nvim",
    -- "mikedfunk/mason-lock.nvim",
    config = true,
    dependencies = { "williamboman/mason.nvim" },
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
}
