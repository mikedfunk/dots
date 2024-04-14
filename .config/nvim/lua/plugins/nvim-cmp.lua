return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    opts.formatting.source_names = vim.tbl_extend("force", opts.formatting.source_names, {
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
      marksman = "󰓾", -- 🞋,
      nerdfont = "󰬴",
      nvim_lsp = "ʪ",
      nvim_lsp_document_symbol = "ʪ",
      nvim_lua = "",
      path = "󰉋", --  
      plugins = "", --  
      vsnip = "✄",
      zk = "",
    })

    opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
      completion = require("cmp").config.window.bordered(),
      documentation = require("cmp").config.window.bordered(),
    })
  end,
}
