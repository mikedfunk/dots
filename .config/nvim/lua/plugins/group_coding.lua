---@return LazyPluginSpec[]
return {
  -- this is included with lazyvim, I'm just changing an option
  -- NOTE: <a-A> (capitalized) will jump ahead out of parens, etc. in insert mode with no plugins!
  {
    "echasnovski/mini.pairs",
    -- enabled = false,
    opts = {
      modes = { command = false }, -- do not auto-pair in command or search mode
    },
  },
  {
    -- add some completion sources
    "hrsh7th/nvim-cmp",
    -- https://github.com/LazyVim/LazyVim/discussions/4549
    -- "iguanacucumber/magazine.nvim",
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
      opts.experimental = { ghost_text = false } -- this conflicts with codeium and similar
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

      -- add more sources
      opts.sources = vim
        .iter({
          opts.sources,
          require("cmp").config.sources({
            { name = "treesitter", entry_filter = no_comments_or_text },
            { name = "emoji" },
            { name = "cmp_jira" },
            { name = "nerdfont" },
            { name = "dictionary", keyword_length = 2, max_item_count = 5 },
            { name = "rg", max_item_count = 5 },
            { name = "tmux", max_item_count = 5 },
          }),
        })
        :flatten()
        :totable()

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
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  -- { "tzachar/highlight-undo.nvim", event = "VeryLazy", config = true },
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
    keys = {
      { "<Leader>ci", "<Cmd>CspellIgnore<CR>", noremap = true, desc = "Cspell Ignore" },
    },
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
}
