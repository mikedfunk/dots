return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = {
      "<leader>cl",
      function()
        require("lspconfig.ui.windows").default_options.border = "rounded"
        require("lspconfig.ui.lspinfo")()
      end,
      desc = "LSP Info",
    }

    keys[#keys + 1] = {
      "<leader>gt",
      "<Cmd>Telescope lsp_type_definitions<CR>",
      desc = "Go to Type Definition",
    }
  end,
  ---@class PluginLspOpts
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      ui = {
        window = {
          border = "rounded",
        },
      },
      servers = {
        flow = {},
        tsserver = {
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json"),
          enabled = vim.fs.find({ "jsconfig.json", "tsconfig.json" }, { path = vim.fn.expand("%"), upward = true })[1]
            ~= nil,
          -- enabled = vim.fn.filereadable("tsconfig.json") == 1 or vim.fn.filereadable("jsconfig.json") == 1,
        },
        phpactor = { enabled = false },
      },
    })
  end,
}

-- local win = require('lspconfig.ui.windows')
-- local _default_opts = win.default_opts
--
-- win.default_opts = function(options)
--   local opts = _default_opts(options)
--   opts.border = 'single'
--   return opts
-- end
