return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "lukas-reineke/cmp-rg",
      "chrisgrieser/cmp-nerdfont",
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      "ray-x/cmp-treesitter",
      {
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
      { "windwp/nvim-autopairs", opts = {} }, -- autoindent on enter in html https://github.com/LazyVim/LazyVim/discussions/1832#discussioncomment-7349902
      -- { "rcarriga/cmp-dap", dependencies = { "mfussenegger/nvim-dap" } },
      -- "luckasRanarison/tailwind-tools.nvim", -- this is also defined in group_ui.lua
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.experimental = { ghost_text = false }
      opts.view = vim.tbl_deep_extend("force", opts.view or {}, {
        entries = { follow_cursor = true },
      })

      local no_comments_or_text = function(entry, _)
        local is_comment = require("cmp").config.context
          and require("cmp").config.context.in_syntax_group
          and require("cmp").config.context.in_syntax_group("Comment")

        return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text" and not is_comment
      end

      -- set nvim_lsp to top priority
      opts.sources[1].priority = 1000
      -- opts.sources[1].entry_filter = no_comments_or_text -- this breaks emmet-language-server

      table.insert(opts.sources, { name = "nvim_lsp_signature_help", entry_filter = no_comments_or_text })
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
          copilot = "", -- 
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
          path = "󰉋", --  
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

        -- use tailwind highlight colors (must come before changing kind)
        -- local ok, tailwind_tools = pcall(require, "tailwind-tools.cmp")
        --
        -- if ok then
        --   item = tailwind_tools.lspkind_format(entry, item)
        -- end

        local icons = require("lazyvim.config").icons.kinds

        if icons[item.kind] then
          -- item.kind = icons[item.kind] .. item.kind
          item.kind = icons[item.kind]
        elseif item.kind == nil then
          item.kind = ""
        else
          item.kind = string.format("[%s]", item.kind)
        end

        -- use icons for source names
        item.menu = kinds[entry.source.name] or string.format("[%s]", entry.source.name)

        return item
      end
      -- }}}
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        "monkoose/neocodeium",
        event = "VeryLazy",
        opts = {
          silent = true,
        },
        dependencies = {
          {
            "folke/which-key.nvim",
            opts = { spec = { { "<leader>a", group = "+ai" } } },
          },
        },
        keys = {
          { "<leader>at", "<Cmd>NeoCodeium toggle<cr>", noremap = true, desc = "Toggle Codeium" },
          {
            "<c-g>",
            function()
              require("neocodeium").accept()
            end,
            mode = "i",
            desc = "Codeium Accept",
          },
          {
            "<c-;>",
            function()
              require("neocodeium").cycle(1)
            end,
            mode = "i",
            desc = "Next Codeium Completion",
          },
          {
            "<c-,>",
            function()
              require("neocodeium").cycle(-1)
            end,
            mode = "i",
            desc = "Prev Codeium Completion",
          },
          {
            "<c-x>",
            function()
              require("neocodeium").clear()
            end,
            mode = "i",
            desc = "Clear Codeium",
          },
        },
      },
    },
    opts = function(_, opts)
      local neocodeium_status_component = {
        function()
          return "󱐋" -- ⚡ 󰲋 󰲌
          -- local on = "󰲋"
          -- local off = "󰲌"
          -- local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
          -- return is_neocodeium_enabled and on or off
        end,
        color = function()
          local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
          local colors = require("tokyonight.colors").setup()

          return {
            fg = is_neocodeium_enabled and colors.green or colors.red,
          }
        end,
        on_click = function()
          if package.loaded["neocodeium"] then
            vim.cmd("NeoCodeium toggle")
          end
        end,
      }

      table.insert(opts.sections.lualine_x, neocodeium_status_component)
    end,
  },
  -- {
  --   "Bryley/neoai.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     {
  --       "folke/which-key.nvim",
  --       opts = { spec = { { "<leader>a", group = "+AI" } } },
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
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },
  -- {
  --   "luckasRanarison/tailwind-tools.nvim",
  --   ft = {
  --     "javascriptreact",
  --     "typescriptreact",
  --     "html",
  --   },
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = {
  --     document_color = { kind = "background" }, -- "inline"|"background"|"foreground"
  --     conceal = { enabled = true },
  --   },
  -- },
  -- { "brenoprata10/nvim-highlight-colors", opts = { enable_tailwind = true } },
  -- { "JosefLitos/colorizer.nvim", event = "VeryLazy", config = true },
  -- { "NvChad/nvim-colorizer.lua", event = "VeryLazy", opts = {} },
  { "tzachar/highlight-undo.nvim", event = "VeryLazy", config = true },
  {
    "haringsrob/nvim_context_vt",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      prefix = "↩ ",
    },
    {
      "tpope/vim-abolish",
      init = function()
        vim.g.abolish_no_mappings = 1
      end,
      config = function()
        vim.cmd("Abolish colleciton collection")
        vim.cmd("Abolish connecitno connection")
        vim.cmd("Abolish conneciton connection")
        vim.cmd("Abolish deafult default")
        vim.cmd("Abolish leagcy legacy")
        vim.cmd("Abolish sectino section")
        vim.cmd("Abolish seleciton selection")
        vim.cmd("Abolish striketrough strikethrough")
        vim.cmd("iabbrev shouldREturn shouldReturn")
        vim.cmd("iabbrev willREturn willReturn")
        vim.cmd("iabbrev willTHrow willThrow")

        vim.keymap.set("n", "<leader>ce", "<Plug>(abolish-coerce)", { noremap = true, silent = true, desc = "Coerce" })
        vim.keymap.set("v", "<leader>ce", "<Plug>(abolish-coerce)", { noremap = true, silent = true, desc = "Coerce" })

        vim.keymap.set(
          "n",
          "<leader>cW",
          "<Plug>(abolish-coerce-word)",
          { noremap = true, silent = true, desc = "Coerce word" }
        )
      end,
    },
  },
  { "tpope/vim-apathy", event = "VeryLazy" },
  { "sickill/vim-pasta", event = "BufRead" },
  -- Alternative: https://github.com/Wansmer/treesj and AndrewRadev/splitjoin.vim
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
        elements = { "[ ]", "[X]", "[-]" },
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
      -- simple hack to force lazy load of Dial first
      { "<CR>", "<Cmd>norm <C-a><CR>", noremap = true, desc = "Dial" },
    },
  },
  -- { "justinsgithub/wezterm-types" },
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
      local colors = require("tokyonight.colors").setup()
      return {
        highlights = {
          covered = { fg = colors.green },
          uncovered = { fg = colors.red },
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
        desc = "Toggle Coverage",
        noremap = true,
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
    "Redoxahmii/json-to-types.nvim",
    build = "sh install.sh npm",
    commands = { "ConvertJSONtoLang", "ConvertJSONtoLangBuffer" },
  },
}
