return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
    "lukas-reineke/cmp-rg",
    "chrisgrieser/cmp-nerdfont",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "ray-x/cmp-treesitter",
    {
      "mikedfunk/cmp-jira",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
    },
    {
      "andersevenrud/cmp-tmux",
      branch = "main",
    },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    -- set nvim_lsp to top priority
    opts.sources[1].priority = 1000

    table.insert(opts.sources, { name = "nvim_lsp_signature_help" })
    table.insert(opts.sources, { name = "treesitter" })
    table.insert(opts.sources, { name = "emoji" })
    table.insert(opts.sources, { name = "cmp_jira" })
    table.insert(opts.sources, { name = "nerdfont" })
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

    opts.formatting.format = function(entry, item)
      local icons = require("lazyvim.config").icons.kinds

      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
      end

      local source_names = opts.formatting.source_names or {}
      item.menu = source_names[entry.source.name] or string.format("(%s)", entry.source.name)

      return item
    end
  end,
}