return {
  "Weissle/persistent-breakpoints.nvim",
  -- ft = {
  --   'php',
  --   'javascript',
  --   'ruby',
  --   'python',
  -- },
  dependencies = { "mfussenegger/nvim-dap", "folke/which-key.nvim" },
  init = function()
    vim.keymap.set("n", "<leader>dt", function()
      require("persistent-breakpoints.api").toggle_breakpoint()
    end, { noremap = true, desc = "Toggle Breakpoint" })
    require("which-key").register({ dt = { "Toggle Breakpoint" } })
    vim.keymap.set("n", "<leader>dX", function()
      require("persistent-breakpoints.api").clear_all_breakpoints()
    end, { noremap = true, desc = "Clear All Breakpoints" })
    require("which-key").register({ dX = { "Clean All Breakpoints" } })
    vim.keymap.set("n", "<leader>de", function()
      require("persistent-breakpoints.api").set_conditional_breakpoint()
    end, { noremap = true, desc = "Expression Breakpoint" })
    require("which-key").register({ de = { "Expression Breakpoint" } })
  end,
  opts = { load_breakpoints_event = { "BufReadPost" } },
}
