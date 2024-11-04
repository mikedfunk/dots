---@return LazyPluginSpec[]
return {
  -- this is included with lazyvim, I'm just changing an option
  {
    "echasnovski/mini.pairs",
    enabled = false,
    -- opts = {
    --   modes = { command = false }, -- do not auto-pair in command or search mode
    -- },
  },
  {
    -- add some completion sources
    -- "hrsh7th/nvim-cmp",
    -- https://github.com/LazyVim/LazyVim/discussions/4549
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji", -- trigger with :\w
      "lukas-reineke/cmp-rg",
      "chrisgrieser/cmp-nerdfont", -- trigger with :nf-
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      "ray-x/cmp-treesitter",
      {
        -- change Jira authentication from oauth to basic auth (API key). Remove debug print.
        "mikedfunk/cmp-jira",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
      },
      { "andersevenrud/cmp-tmux", branch = "main" },
      {
        "uga-rosa/cmp-dictionary",
        opts = {
          paths = { "/usr/share/dict/words" },
        },
      },
      -- {
      --   -- autoindent on enter in html https://github.com/LazyVim/LazyVim/discussions/1832#discussioncomment-7349902
      --   "windwp/nvim-autopairs",
      --   opts = {},
      -- },
      -- { "rcarriga/cmp-dap", dependencies = { "mfussenegger/nvim-dap" } },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- opts.experimental = { ghost_text = false } -- this conflicts with codeium and similar
      opts.view = vim.tbl_deep_extend("force", opts.view or {}, {
        entries = { follow_cursor = true },
      })

      ---@param entry cmp.Entry
      ---@return boolean
      local no_comments_or_text = function(entry, _)
        local is_comment = require("cmp").config.context
          and require("cmp").config.context.in_syntax_group
          and require("cmp").config.context.in_syntax_group("Comment")

        return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text" and not is_comment
      end

      -- set nvim_lsp to top priority
      opts.sources[1].priority = 1000
      -- opts.sources[1].entry_filter = no_comments_or_text -- this breaks emmet-language-server

      -- table.insert(opts.sources, { name = "nvim_lsp_signature_help", entry_filter = no_comments_or_text })
      -- table.insert(opts.sources, { name = "dap-repl"})
      -- table.insert(opts.sources, { name = "dapui_watches"})
      -- table.insert(opts.sources, { name = "dapui_hover"})
      table.insert(opts.sources, { name = "treesitter", entry_filter = no_comments_or_text })
      table.insert(opts.sources, { name = "emoji" })
      table.insert(opts.sources, { name = "cmp_jira" })
      table.insert(opts.sources, { name = "git" })
      table.insert(opts.sources, { name = "nerdfont" })
      table.insert(opts.sources, { name = "dictionary", keyword_length = 2, max_item_count = 5 })
      table.insert(opts.sources, { name = "rg", max_item_count = 5 })
      table.insert(opts.sources, { name = "tmux", max_item_count = 5 })

      opts.mapping["<CR>"] = require("cmp").mapping.confirm({ select = false })
      opts.preselect = require("cmp").PreselectMode.None
      opts.completion.completeopt = "menu,menuone,noselect"

      opts.formatting.fields = { "kind", "abbr", "menu" }

      opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
        completion = require("cmp").config.window.bordered(),
        documentation = require("cmp").config.window.bordered(),
      })

      -- poor man's lspkind {{{
      opts.formatting.format = function(entry, item)
        -- create and assign highlights with different foreground colors for each source {{{
        local all_colors = require("tokyonight.colors").setup()
        local colors = {
          all_colors.blue,
          all_colors.blue0,
          all_colors.blue1,
          all_colors.blue2,
          all_colors.blue5,
          all_colors.blue6,
          -- all_colors.blue7,
          all_colors.cyan,
          all_colors.green,
          all_colors.green1,
          all_colors.green2,
          all_colors.magenta,
          all_colors.magenta2,
          all_colors.orange,
          all_colors.purple,
          all_colors.red,
          all_colors.red1,
          all_colors.teal,
          all_colors.yellow,
        }

        local kinds = vim.tbl_extend("force", require("lazyvim.config").icons.kinds, {
          buffer = "",
          ["buffer-lines"] = "≡",
          calc = "",
          cmp_jira = "",
          cmp_tabnine = "➒", --  󰚩
          color_names = "",
          codeium = LazyVim.config.icons.kinds.Codeium,
          copilot = LazyVim.config.icons.kinds.Copilot, --  
          dap = "",
          dictionary = "",
          doxygen = "", -- 󰙆
          emoji = "☻", --  
          git = "", -- 
          jira_issues = "",
          luasnip = "", -- ✄ ✂
          luasnip_choice = "",
          marksman = "", -- 🞋 󰓾
          nerdfont = "󰬴",
          nvim_lsp = "ʪ",
          nvim_lsp_document_symbol = "ʪ",
          nvim_lsp_signature_help = "ʪ",
          nvim_lua = "",
          path = LazyVim.config.icons.kinds.Folder, -- "󰉋", --  
          plugins = "", --  
          rg = "", -- 
          snippets = "",
          tmux = "",
          treesitter = "",
          ["vim-dadbod-completion"] = "",
          vsnip = "",
          zk = "",
        })

        local i = 0

        for kind, _ in pairs(kinds) do
          i = i + 1

          if not colors[i] then
            i = 1
          end

          local color = colors[i]

          vim.api.nvim_set_hl(0, "CmpItemKind_" .. kind, { fg = color })
        end

        item.kind_hl_group = "CmpItemKind_" .. entry.source.name
        -- }}}

        local icons = require("lazyvim.config").icons.kinds
        item.kind = icons[item.kind] or (item.kind == nil and "" or string.format("[%s]", item.kind))
        item.menu = kinds[entry.source.name] or string.format("[%s]", entry.source.name)

        return item
      end
      -- }}}
    end,
  },
  {
    -- add some lualine components to display some more things in the statusline
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        -- main config for neocodeium AI completion. Nested under lualine because I also add a lualine component.
        "monkoose/neocodeium",
        event = "VeryLazy",
        opts = {
          silent = true,
          filter = function(bufnr)
            local excluded_filetypes = {
              "DressingInput",
              "NvimTree",
              "TelescopePrompt",
              "TelescopeResults",
              "alpha",
              "dashboard",
              "harpoon",
              "lazy",
              "lspinfo",
              "neoai-input",
              "starter",
            }

            if vim.tbl_contains(excluded_filetypes, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
              return false
            end

            return true
          end,
          -- show_label = false,
        },
        dependencies = {
          {
            -- add AI section to which-key
            "folke/which-key.nvim",
            opts = { spec = { { "<leader>a", group = "+ai" } } },
          },
        },
        keys = {
          { "<leader>at", "<Cmd>NeoCodeium toggle<cr>", noremap = true, desc = "Toggle Codeium" },
          {
            "<a-cr>",
            function()
              require("neocodeium").accept()
            end,
            mode = "i",
            desc = "Codeium Accept",
          },
          {
            "<a-w>",
            function()
              require("neocodeium").accept_word()
            end,
            mode = "i",
            desc = "Codeium Accept Word",
          },
          {
            "<a-l>",
            function()
              require("neocodeium").accept_line()
            end,
            mode = "i",
            desc = "Codeium Accept Line",
          },
          {
            "<a-n>",
            function()
              require("neocodeium").cycle(1)
            end,
            mode = "i",
            desc = "Next Codeium Completion",
          },
          {
            "<a-p>",
            function()
              require("neocodeium").cycle(-1)
            end,
            mode = "i",
            desc = "Prev Codeium Completion",
          },
          {
            "<a-c>",
            function()
              require("neocodeium").clear()
            end,
            mode = "i",
            desc = "Clear Codeium",
          },
        },
      },
    },
    ---Add some lualine components
    ---@class LuaLineOpts
    ---@field sections table
    ---@param opts LuaLineOpts
    opts = function(_, opts)
      local get_lsp_client_names = function()
        local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

        ---@type string[]
        local buf_client_names = {}

        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
          end
        end

        ---@type string[]
        buf_client_names = vim.fn.uniq(buf_client_names) ---@diagnostic disable-line missing-parameter
        return buf_client_names
      end

      local lsp_status_component = {
        ---@return string
        function()
          return "ʪ " .. tostring(#get_lsp_client_names())
        end,
        color = function()
          return {
            fg = #get_lsp_client_names() > 0 and LazyVim.ui.fg("Normal").fg or LazyVim.ui.fg("Comment").fg,
            gui = "None",
          }
        end,
        on_click = function()
          vim.cmd("LspInfo")
        end,
      }

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

      ---@return string[]
      local function get_linters()
        local linters = { unpack(require("lint").linters_by_ft[vim.bo.ft] or {}) }
        for _, linter in ipairs(vim.g.ale_linters and vim.g.ale_linters[vim.bo.ft] or {}) do
          if not vim.tbl_contains(linters, linter) then
            table.insert(linters, linter)
          end
        end

        return linters
      end

      local nvim_lint_component = {
        ---@return string
        function()
          return " " .. tostring(#get_linters())
        end,
        color = function()
          return {
            fg = #get_linters() > 0 and LazyVim.ui.fg("Normal").fg or LazyVim.ui.fg("Comment").fg,
            gui = "None",
          }
        end,
        cond = function()
          return package.loaded["lint"] ~= nil
        end,
        on_click = function()
          print(vim.inspect(get_linters()))
        end,
      }

      local neocodeium_status_component = {
        function()
          return LazyVim.config.icons.kinds.Codeium
          -- return "󰌶" --  󱙺 󰌵 󱐋 ⚡ 󰲋 󰲌󰚩 
          -- local on = "󰲋"
          -- local off = "󰲌"
          -- local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
          -- return is_neocodeium_enabled and on or off
        end,
        color = function()
          local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
          return {
            fg = is_neocodeium_enabled and LazyVim.ui.fg("Normal").fg or LazyVim.ui.fg("Comment").fg,
            -- fg = is_neocodeium_enabled and LazyVim.ui.fg("DiagnosticOk").fg or LazyVim.ui.fg("DiagnosticError").fg,
          }
        end,
        on_click = function()
          if package.loaded["neocodeium"] then
            vim.cmd("NeoCodeium toggle")
          end
        end,
        cond = function()
          return package.loaded["neocodeium"] ~= nil
        end,
      }

      table.insert(opts.sections.lualine_x, neocodeium_status_component)
      table.insert(opts.sections.lualine_x, lsp_status_component)
      table.insert(opts.sections.lualine_x, nvim_lint_component)
      table.insert(opts.sections.lualine_x, conform_nvim_component)
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  { "tzachar/highlight-undo.nvim", event = "VeryLazy", config = true },
  {
    "haringsrob/nvim_context_vt",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      prefix = "↩ ",
    },
  },
  { "tpope/vim-apathy", event = "VeryLazy" },
  { "sickill/vim-pasta", event = "BufRead" },
  { "echasnovski/mini.splitjoin", event = "VeryLazy", opts = {} },
  {
    "tpope/vim-projectionist",
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = { spec = { { "<leader>A", group = "+alternate" } } },
      },
    },
    lazy = false,
    -- event = "BufRead",
    commands = {
      "A",
      "AV",
      "AS",
      "AT",
    },
    keys = {
      { "<leader>Aa", "<Cmd>A<CR>", noremap = true, desc = "Alternate file" },
      { "<leader>Av", "<Cmd>AV<CR>", noremap = true, desc = "Alternate vsplit" },
      { "<leader>As", "<Cmd>AS<CR>", noremap = true, desc = "Alternate split" },
      { "<leader>At", "<Cmd>AT<CR>", noremap = true, desc = "Alternate tab" },
    },
  },
  {
    "monaqa/dial.nvim",
    opts = function()
      local opts = require("lazyvim.plugins.extras.editor.dial").opts()
      local augend = require("dial.augend")

      local checkboxes = augend.constant.new({
        -- pattern_regexp = "\\[.]\\s", -- TODO: doesn't work
        elements = { "[ ]", "[x]", "[-]" },
        word = false,
        cyclic = true,
      })

      table.insert(opts.groups.markdown, checkboxes)

      opts.dials_by_ft.php = "php"
      opts.groups.php = opts.groups.php or {}

      table.insert(opts.groups.php, augend.constant.new({ elements = { "public", "private", "protected" } }))
      table.insert(opts.groups.php, augend.constant.new({ elements = { "abstract", "final" } }))
      table.insert(
        opts.groups.php,
        augend.case.new({
          types = { "camelCase", "PascalCase", "snake_case", "kebab-case", "SCREAMING_SNAKE_CASE" },
          cyclic = true,
        })
      )
      table.insert(
        opts.groups.php,
        augend.constant.new({
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        })
      )
      table.insert(
        opts.groups.php,
        augend.constant.new({ elements = { "true", "false" }, word = false, cyclic = true })
      )
      table.insert(opts.groups.php, augend.integer.alias.decimal)
      table.insert(opts.groups.php, augend.date.alias["%Y-%m-%d"])

      return opts
    end,
    keys = {
      { "<CR>", "<Cmd>norm <C-a><CR>", mode = "n", noremap = true, desc = "Dial" },
    },
  },
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/tokyonight.nvim",
      {
        -- needed for nvim-coverage PHP cobertura parser. Requires `brew install luajit`
        "vhyrro/luarocks.nvim",
        opts = {
          rocks = { "lua-xmlreader" },
        },
      },
    },
    opts = function()
      return {
        highlights = {
          covered = { fg = LazyVim.ui.fg("DiagnosticOk").fg },
          uncovered = { fg = LazyVim.ui.fg("DiagnosticError").fg },
        },
        auto_reload = true,
        lcov_file = "./coverage/lcov.info",
      }
    end,
    keys = {
      {
        "<leader>tc",
        function()
          if require("coverage.signs").is_enabled() then
            require("coverage").clear()
          else
            require("coverage").load(true)
          end
        end,
        noremap = true,
        desc = "Toggle Coverage",
      },
    },
  },
  {
    "idanarye/nvim-impairative",
    config = function()
      require("impairative.replicate-unimpaired")()
    end,
  },
  {
    "ChrisLetter/cspell-ignore",
    opts = { cspell_path = "./cspell.json" },
    commands = { "CspellIgnore" },
  },
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "hurl",
    -- keys = {
    --   -- Run API request
    --   { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
    --   { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
    --   { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
    --   { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
    --   { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
    --   -- Run Hurl request in visual mode
    --   { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    -- },
  },
  -- {
  --   "Bryley/neoai.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     {
  --       "folke/which-key.nvim",
  --       opts = { spec = { { "<leader>a", group = "+ai" } } },
  --     },
  --   },
  --   -- expects OPENAI_API_KEY env var to be set
  --   opts = {
  --     models = {
  --       {
  --         name = "openai",
  --         -- model = "gpt-3.5-turbo",
  --         model = "gpt-4",
  --         params = nil,
  --       },
  --     },
  --   },
  --   cmd = {
  --     "NeoAI",
  --     "NeoAIOpen",
  --     "NeoAIClose",
  --     "NeoAIToggle",
  --     "NeoAIContext",
  --     "NeoAIContextOpen",
  --     "NeoAIContextClose",
  --     "NeoAIInject",
  --     "NeoAIInjectCode",
  --     "NeoAIInjectContext",
  --     "NeoAIInjectContextCode",
  --   },
  --   keys = {
  --     { "<Leader>ai", "<cmd>NeoAIToggle<cr>", desc = "NeoAI Chat", noremap = true },
  --     { "<Leader>ac", "<cmd>NeoAIContext<cr>", desc = "NeoAI Context", noremap = true },
  --     { "<Leader>ac", "<cmd>'<,'>NeoAIContext<cr>", desc = "NeoAI Context", noremap = true, mode = "v" },
  --     { "<Leader>as", desc = "NeoAI Summarize", mode = "v" },
  --     { "<Leader>ag", desc = "NeoAI Commit Message" },
  --   },
  -- },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = "openai" },
        inline = { adapter = "openai" },
        agent = { adapter = "openai" },
        -- chat = { adapter = "ollama" },
        -- inline = { adapter = "ollama" },
        -- agent = { adapter = "ollama" },
      },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    keys = {
      {
        "<Leader>ai",
        "<Cmd>CodeCompanionChat Toggle<CR>",
        mode = { "n", "v" },
        desc = "Toggle CodeCompanion Chat",
        noremap = true,
      },
      {
        "<Leader>aa",
        "<Cmd>CodeCompanionActions<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Actions",
        noremap = true,
      },
      { "<a-a>", "<Cmd>CodeCompanionActions<CR>", mode = "i", desc = "CodeCompanion Actions", noremap = true },
    },
  },
}
