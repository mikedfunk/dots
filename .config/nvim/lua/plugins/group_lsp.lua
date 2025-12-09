-- vim.lsp.set_log_level("debug")

return {
  -- TODO: trying to use this to add macos arm64 version of laravel-ls, but can't get it to work yet
  -- {
  --   "mason-org/mason.nvim",
  --   opts = {
  --     registries = {
  --       "lua:~/.local/share/nvim/mason-registry",
  --       "github:mason-org/mason-registry",
  --     },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    -- TODO: not working
    opts_extend = {
      "servers.snyk_ls.filetypes",
      "servers.emmet_language_server.filetypes",
    },
    ---@class PluginLspOpts
    opts = {
      codelens = { enabled = true },
      servers = {
        apex_ls = {
          apex_jar_path = vim.fn.stdpath("data") .. "/mason/share/apex-language-server/apex-jorje-lsp.jar",
          apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to surface semantic errors
          apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
        },
        biome = {},
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#copilot
        -- copilot = { telemetry = { telemetryLevel = "none" } },
        bqls = { enabled = false }, -- to use this LS, :LspStop then :LspStart bqls
        codebook = {
          filetypes = {
            "c",
            "css",
            "gitcommit",
            "go",
            "haskell",
            "html",
            "java",
            "javascript",
            "javascriptreact",
            "lua",
            -- "markdown", -- just use vim spelling for this
            "php",
            "python",
            "ruby",
            "rust",
            "toml",
            -- "text",
            "typescript",
            "typescriptreact",
          },
        },
        contextive = {
          root_markers = { ".contextive" },
          -- root_dir = function(startpath)
          --   return require("lspconfig.util").root_pattern(".contextive")(startpath)
          -- end,
          enabled = false, -- to use this LS, :LspStop then :LspStart contextive
        },
        cssls = {
          filetypes = { "css" }, -- replace filetypes
        },
        cssmodules_ls = {},
        cucumber_language_server = {},
        denols = {
          root_markers = { "deno.json" },
          -- root_dir = function(startpath)
          --   return require("lspconfig.util").root_pattern("deno.json")(startpath)
          -- end,
        },
        -- expert = {}, -- elixir
        eslint = { enabled = vim.fn.executable("eslint") == 1 },
        emmet_language_server = {
          filetypes = { "javascript" }, -- add more filetypes
          settings = {
            emmet = {
              includedLanguages = {
                javascript = "javascriptreact",
                typescript = "typescriptreact",
              },
              syntaxProfiles = {
                jsx = {
                  self_closing_tag = true,
                  filters = "bem",
                },
              },
            },
          },
        },
        -- flow = {},
        groovyls = {},
        -- harper_ls = {
        --   settings = {
        --     ["harper-ls"] = {
        --       linters = {
        --         SpellCheck = false,
        --         SentenceCapitalization = false,
        --       },
        --       userDictPath = vim.env.XDG_CONFIG_HOME .. "/nvim/spell/en.utf-8.add"
        --     }
        --   }
        -- }, -- annoying grammar checker that usually reports false positives in code
        intelephense = {
          settings = {
            intelephense = {
              environment = { shortOpenTag = false },
              codelens = {
                implementations = { enable = false },
                overrides = { enable = false },
                parent = { enable = false },
                references = { enable = false },
                usages = { enable = false },
              },
              completion = {
                fullyQualifyGlobalConstantsAndFunctions = true,
                suggestObjectOperatorStaticMethods = false,
                maxItems = 30,
              },
              phpdoc = {
                returnVoid = false,
                classTemplate = { tags = {} },
              },
              rename = { namespaceMode = "all" },
              telemetry = { enable = false },
              files = {
                exclude = {
                  "**/.git/**",
                  "**/.DS_Store",
                  "**/node_modules/**",
                  "**/vendor/**/{Tests,tests,Test,test,Spec,spec,Specs,specs}/**",
                  "**/vendor/**/vendor/**",
                  "**/coverage/**",
                },
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = {
                { fileMatch = { "crush.json" }, url = "https://charm.land/crush.json" },
              },
            },
          },
          -- TODO: trying to fix this: Problems loading reference 'vscode://schemas/settings/machine': Unable to load schema from 'vscode://schemas/settings/machine': MethodNotFound.
          -- settings = {
          --   json = {
          --     schemas = require("schemastore").json.schemas({
          --       replace = {
          --         ["devcontainer.json"] = "https://raw.githubusercontent.com/devcontainers/spec/refs/heads/main/schemas/devContainer.base.schema.json",
          --       },
          --     }),
          --     validate = { enable = true },
          --   },
          -- },
        },
        -- TODO: mason doesn't recognize arm64 build so I installed with mise. Switch when available.
        laravel_ls = {
          mason = false,
          -- fix bug with root_dir throwing an error for this ls
          root_dir = function(startpath)
            return require("lspconfig.util").root_pattern("artisan")(startpath)
          end,
        },
        lemminx = {},
        -- lsp_ai = {},
        marksman = { enabled = false },
        ---@see https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/snyk_ls.lua
        ---@see https://github.com/snyk/snyk-ls#configuration-1
        snyk_ls = {
          filetypes = { "php" }, -- add more filetypes
          -- filetypes = {
          --   "go",
          --   "gomod",
          --   "javascript",
          --   "typescript",
          --   "json",
          --   "python",
          --   "requirements",
          --   "helm",
          --   "yaml",
          --   "terraform",
          --   "terraform-vars",
          --   "php",
          -- },
          init_options = {
            token = os.getenv("SNYK_TOKEN"), -- docs say it will auto read the env var but it doesn't work :/
            enableTrustedFoldersFeature = "false",
            enableTelemetry = "false",
            organization = "leaf-saatchiart",
          },
        },
        -- phpactor = {},
        somesass_ls = {},
        -- sqlfluff = {},
        sqlls = {
          settings = {
            sqlLanguageServer = {
              lint = {
                rules = {
                  ["reserved-word-case"] = { "error", "lower" },
                },
              },
            },
          },
        },
        ---@vim.LspConfig
        tailwindcss = {
          -- reduce this from the insanely huge list to just the ones I would possible use it for
          -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tailwindcss
          filetypes = {
            "html",
            "css",
            "sass",
            "scss",
            "stylus",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
          },
          root_markers = {
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "tailwind.config.cts",
            "tailwind.config.mts",
          },
          -- root_dir = function(startpath)
          --   return require("lspconfig.util").root_pattern(
          --     "tailwind.config.js",
          --     "tailwind.config.cjs",
          --     "tailwind.config.mjs",
          --     "tailwind.config.ts",
          --     "tailwind.config.cts",
          --     "tailwind.config.mts"
          --   )(startpath)
          -- end,
        },
        taplo = {},
        vtsls = {
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
            },
          },
        },
        -- For some reason this root_dir function now breaks vtsls - it never starts
        -- vtsls = {
        --   root_dir = function(startpath)
        --     return require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json")(startpath)
        --   end,
        --   -- single_file_support = false, -- deprecated
        --   workspace_required = true,
        -- },
        yamlls = {
          settings = {
            flags = {
              debounce_text_changes = 500,
            },
            schemas = {
              ["https://json.schemastore.org/pre-commit-config.json"] = ".pre-commit-config.yaml",
            },
          },
        },
        zk = {}, -- because marksman crashes a lot
      },
    },
  },
  -- {
  --   "kitagry/bqls.nvim",
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   config = function()
  --     require("lspconfig").bqls.setup({
  --       init_options = {
  --         project_id = "BIGQUERY_PROJECT_ID",
  --       },
  --     })
  --   end,
  -- },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
      sign = {
        text = "",
        hl = "DiagnosticSignWarn",
      },
    },
  },
  -- mouse hover to lsp hover
  {
    "soulis-1256/eagle.nvim",
    event = "LspAttach",
    opts = {
      border = "rounded",
    },
  },
  {
    "zapling/mason-lock.nvim",
    branch = "feat/support-mason2", -- TODO: when are they going to merge this?
    opts = {},
    dependencies = { "mason-org/mason.nvim" },
  },
  -- {
  --   "antosha417/nvim-lsp-file-operations",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   event = "LspAttach",
  --   opts = {},
  --   init = function()
  --     local lspconfig = require("lspconfig")
  --
  --     -- Set global defaults for all servers
  --     lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  --       capabilities = vim.tbl_deep_extend(
  --         "force",
  --         vim.lsp.protocol.make_client_capabilities(),
  --         -- returns configured operations if setup() was already called
  --         -- or default operations if not
  --         require("lsp-file-operations").default_capabilities()
  --       ),
  --     })
  --   end,
  -- },
  -- {
  --   "rachartier/tiny-inline-diagnostic.nvim",
  --   priority = 1000, -- needs to be loaded in first
  --   config = function()
  --     require("tiny-inline-diagnostic").setup()
  --     vim.diagnostic.config({ virtual_text = false })
  --   end,
  -- },
  -- Buggy and slow when lots of usages. Breaks on dropbar.
  -- Overlaps with LSP codelens references
  -- {
  --   "Wansmer/symbol-usage.nvim",
  --   enabled = false,
  --   event = "LspAttach",
  --   opts = { vt_position = "end_of_line" },
  -- },
  {
    "Sebastian-Nielsen/better-type-hover",
    ft = { "typescript", "typescriptreact" },
    opts = {},
  },
  -- get a hierarchical tree of references with :FunctionReferences (only if lsp feature is supported)
  -- { "lafarr/hierarchy.nvim", event = "LspAttach", opts = {} },
  -- { "m-demare/hlargs.nvim", opts = {} },
}
