return {
  "nyngwang/NeoZoom.lua",
  dependencies = "folke/which-key.nvim",
  -- ft = { 'dapui_.*', 'dap-repl' },
  cmd = { "NeoZoomToggle", "NeoZoom" },
  init = function()
    require("which-key").register({
      z = {
        function()
          vim.cmd("NeoZoomToggle")
        end,
        "Toggle Zoom",
      },
    }, { prefix = "<C-w>" })
  end,
  opts = {
    presets = {
      {
        filetypes = { "dapui_.*", "dap-repl" },
        config = {
          top_ratio = 0.25,
          left_ratio = 0.6,
          width_ratio = 0.4,
          height_ratio = 0.65,
        },
        -- callbacks = {
        --   function() vim.wo.wrap = true end,
        -- },
      },
    },
  },
}
