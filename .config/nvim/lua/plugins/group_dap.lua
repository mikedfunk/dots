return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      {
        "folke/edgy.nvim",
        opts_extend = { "bottom" },
        opts = {
          bottom = {
            { title = "Scopes", ft = "dapui_scopes" },
            { title = "Stacks", ft = "dapui_stacks" },
            { title = "Breakpoints", ft = "dapui_breakpoints" },
            { title = "Stacks", ft = "dapui_stacks" },
            { title = "Watches", ft = "dapui_watches" },
            { title = "Console", ft = "dapui_console" },
            { title = "Repl", ft = "dap-repl" },
          },
        },
      },
    },
    opts = {
      layouts = {
        {
          elements = {
            "scopes",
            -- "stacks",
            "breakpoints",
            "stacks",
            "watches",
            "repl",
            -- "console",
          },
          position = "bottom",
          size = 10,
        },
      },
    },
  },
  {
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
  },
}
