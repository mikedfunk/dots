return {
  "nvimdev/dashboard-nvim",
  opts = function()
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    return {
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = {
          [[                                     ]],
          [[      __                _            ]],
          [[   /\ \ \___  ___/\   /(_)_ __ ___   ]],
          [[  /  \/ / _ \/ _ \ \ / | | '_ ` _ \  ]],
          [[ / /\  |  __| (_) \ V /| | | | | | | ]],
          [[ \_\ \/ \___|\___/ \_/ |_|_| |_| |_| ]],
          [[                                     ]],
        },
        shortcut = {
          -- { action = LazyVim.telescope("files"), desc = " Find File", icon = " ", key = "f" },
          { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
          -- { action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
          -- { action = "Telescope live_grep", desc = " Find Text", icon = " ", key = "g" },
          { action = [[lua LazyVim.telescope.config_files()()]], desc = " Config", icon = " ", key = "c" },
          { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
          -- { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
          { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
      }
    }
  end
}
