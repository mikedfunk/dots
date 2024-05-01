return {
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
    {
      "petertriho/cmp-git",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = true,
    }, -- expects GITHUB_API_TOKEN env var to be set
    { "windwp/nvim-autopairs", opts = {} }, -- autoindent on enter in html https://github.com/LazyVim/LazyVim/discussions/1832#discussioncomment-7349902
    -- { "rcarriga/cmp-dap", dependencies = { "mfussenegger/nvim-dap" } },
    "luckasRanarison/tailwind-tools.nvim", -- this is also defined in group_ui.lua
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

      local source_names = opts.formatting.source_names or {}
      source_names = vim.tbl_extend("force", source_names, {
        buffer = "",
        ["buffer-lines"] = "≡",
        calc = "",
        cmp_jira = "",
        cmp_tabnine = "󰚩", --  ➒,
        color_names = "",
        copilot = "",
        dap = "",
        dictionary = "",
        doxygen = "", -- 󰙆
        emoji = "", -- 
        git = "",
        jira_issues = "",
        luasnip = "✄",
        luasnip_choice = "",
        marksman = "󰓾", -- 🞋
        nerdfont = "󰬴",
        nvim_lsp = "ʪ",
        nvim_lsp_document_symbol = "ʪ",
        nvim_lsp_signature_help = "ʪ",
        nvim_lua = "",
        path = "󰉋", --  
        plugins = "", --  
        rg = "",
        tmux = "",
        treesitter = "",
        ["vim-dadbod-completion"] = "",
        vsnip = "✄",
        zk = "",
      })

      local i = 0

      for source_name, _ in pairs(source_names) do
        i = i + 1

        if not colors[i] then
          i = 1
        end

        local color = colors[i]

        vim.api.nvim_set_hl(0, "CmpItemKind_" .. source_name, { fg = color })
      end

      item.kind_hl_group = "CmpItemKind_" .. entry.source.name
      -- }}}

      -- use tailwind highlight colors (must come before changing kind)
      item = require("tailwind-tools.cmp").lspkind_format(entry, item)

      local icons = require("lazyvim.config").icons.kinds

      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
      end

      -- use icons for source names
      item.menu = source_names[entry.source.name] or string.format("[%s]", entry.source.name)

      return item
    end
    -- }}}
  end,
}
