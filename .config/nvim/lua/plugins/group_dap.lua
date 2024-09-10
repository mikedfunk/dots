return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "LiadOz/nvim-dap-repl-highlights",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = true,
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = { "php" },
      },
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = { "mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim" },
      keys = {
        { "<Leader>dL", "<Cmd>Telescope dap breakpoints<CR>", noremap = true, desc = "Telescope List Breakpoints" },
        { "<Leader>dV", "<Cmd>Telescope dap variables<CR>", noremap = true, desc = "Telescope List Variables" },
        { "<Leader>dF", "<Cmd>Telescope dap frames<CR>", noremap = true, desc = "Telescope Call Stack" },
      },
      config = function()
        require("telescope").load_extension("dap")
      end,
    },
    {
      "ofirgall/goto-breakpoints.nvim",
      dependencies = { "mfussenegger/nvim-dap" },
      keys = {
        {
          "]B",
          function()
            require("goto-breakpoints").next()
          end,
          desc = "Go to Next Breakpoint",
        },
        {
          "[B",
          function()
            require("goto-breakpoints").next()
          end,
          desc = "Go to Previous Breakpoint",
        },
      },
    },
    {
      "Weissle/persistent-breakpoints.nvim",
      dependencies = { "mfussenegger/nvim-dap" },
      opts = {
        load_breakpoints_event = { "BufReadPost" },
      },
      keys = {
        {
          "<leader>dT",
          function()
            require("persistent-breakpoints.api").toggle_breakpoint()
          end,
          noremap = true,
          desc = "Toggle Breakpoint (Persistent)",
        },
        {
          "<Leader>dX",
          function()
            require("persistent-breakpoints.api").clear_all_breakpoints()
          end,
          noremap = true,
          desc = "Clear All Breakpoints (Persistent)",
        },
        {
          "<Leader>dE",
          function()
            require("persistent-breakpoints.api").set_conditional_breakpoint()
          end,
          noremap = true,
          desc = "Breakpoint Condition (Persistent)",
        },
      },
    },
  },
}
