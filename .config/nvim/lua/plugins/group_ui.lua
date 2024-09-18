return {
  { "SmiteshP/nvim-navic", opts = { separator = "  " } },
  -- { "Bekaboo/dropbar.nvim", dependencies = { "nvim-telescope/telescope-fzf-native.nvim" } },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
      { "<leader>uz", "<Cmd>Twilight<CR>", noremap = true, desc = "Twilight" },
    },
    config = true,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options, {
        persist_buffer_sort = true,
        hover = { enabled = true },
        sort_by = "insert_after_current",
        always_show_bufferline = true,
        style_preset = require("bufferline").style_preset.no_italic,
        separator_style = "slant",
        groups = {
          items = {
            require("bufferline.groups").builtin.pinned:with({ icon = "" }),
          },
        },
      })
    end,
  },
  { "folke/which-key.nvim", opts = { win = { border = "rounded" } } },
  { "LazyVim/LazyVim", opts = { ui = { border = "rounded" } } },
  {
    "cormacrelf/dark-notify",
    lazy = false,
    config = function() -- can receive mode: "dark"|"light"
      require("dark_notify").run({
        onchange = function()
          vim.cmd("silent! !tmux source ~/.config/tmux/tmux.conf &")
        end,
      })
    end,
  },
  -- { "itchyny/vim-highlighturl", event = "VeryLazy" },
  { "rubiin/highlighturl.nvim", event = "VeryLazy" },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "seanbreckenridge/gitsigns-yadm.nvim" },
    opts = {
      _on_attach_pre = function(_, callback)
        require("gitsigns-yadm").yadm_signs(callback)
      end,
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      handlers = { gitsigns = true },
      handle = {
        highlight = "PmenuSel",
      },
      excluded_filetypes = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "harpoon",
        "lazy",
        "lspinfo",
        "starter",
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      {
        "rubiin/fortune.nvim",
        opts = {
          display_format = "mixed",
          custom_quotes = {
            short = {},
            long = require("config.programming_quotes").quotes,
          },
        },
      },
    },
    -- copy/paste from lazyvim config except for header and footer
    opts = function()
      local logo = {
        " ██████   █████                   █████   █████  ███                 ",
        "░░██████ ░░███                   ░░███   ░░███  ░░░                  ",
        " ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████  ",
        " ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███ ",
        " ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███ ",
        " ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███ ",
        " █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████",
        "░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░ ",
      }

      logo = vim.list_extend(vim.split(string.rep("\n", 8), "\n"), logo)
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      logo = vim.list_extend(logo, { "", "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms", "" })

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = logo,
          -- stylua: ignore
          center = {
            { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
            { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
            { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
            { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
            { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            return require("fortune").get_fortune()
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "qf",
  },
  { "nvim-zh/colorful-winsep.nvim", event = "WinNew", config = true },
  {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle", "NeoZoom" },
    keys = {
      { "<C-w>z", "<cmd>NeoZoomToggle<cr>", noremap = true, desc = "Toggle Zoom" },
    },
    opts = {},
  },
  -- {
  --   -- this expects the extra lazyvim.plugins.extras.ui.mini-animate to be
  --   -- enabled in lazy.lua. It just tweaks the timing.
  --   "echasnovski/mini.animate",
  --   opts = function(_, opts)
  --     -- speed it up
  --     opts.resize.timing = require("mini.animate").gen_timing.cubic({ duration = 75, unit = "total" })
  --     opts.scroll.timing = require("mini.animate").gen_timing.cubic({ duration = 35, unit = "total" })
  --   end,
  -- },
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        -- speed it up
        delay = 50,
        animation = require("mini.indentscope").gen_animation.cubic({ duration = 70, unit = "total" }),
      },
    },
  },
  { "folke/edgy.nvim", opts = { animate = { cps = 200 } } }, -- speed up animation
  {
    "Isrothy/neominimap.nvim",
    lazy = false,
    init = function()
      vim.g.neominimap = {
        auto_enable = false,
        excluded_filetypes = {
          "DressingInput",
          "TelescopePrompt",
          "alpha",
          "dashboard",
          "harpoon",
          "lazy",
          "lspinfo",
          "starter",
          "help",
        },
      }
    end,
    keys = {
      { "<leader>um", "<Cmd>Neominimap toggle<CR>", desc = "Toggle Minimap" },
    },
  },
  {
    "b0o/incline.nvim",
    opts = {
      hide = { only_win = true },
      window = { winhighlight = { active = { Normal = "CursorLineSign" } } },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000, -- increase the time that the notification stays on the screen
    },
  },
  {
    "folke/noice.nvim",
    commit = "d9328ef903168b6f52385a751eb384ae7e906c6f", -- https://github.com/folke/noice.nvim/issues/921#issuecomment-2253363579
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      ---@class NoiceConfigViews
      -- views = {
      --   notify = {
      --     backend = "notify_send",
      --   },
      -- },
      -- https://github.com/folke/noice.nvim/discussions/364
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "lsp",
            find = "snyk",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "edkolev/tmuxline.vim",
    init = function()
      local function set_tmuxline_theme()
        if vim.o.background == "dark" then
          vim.g["tmuxline_theme"] = {
            a = { "16", "254", "bold" },
            b = { "247", "236" },
            c = { "250", "233" },
            x = { "250", "233" },
            y = { "247", "236" },
            z = { "235", "252" },
            bg = { "247", "234" },
            win = { "250", "234" },
            ["win.dim"] = { "244", "234" },
            cwin = { "231", "31", "bold" },
            ["cwin.dim"] = { "117", "31" },
          }
          vim.cmd("command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.config/tmux/tmuxline-dark.conf") -- apply tmuxline settings and snapshot to file

          return
        end

        vim.g["tmuxline_theme"] = {
          a = { "238", "253", "bold" },
          b = { "255", "238" },
          c = { "255", "236" },
          x = { "255", "236" },
          y = { "255", "238" },
          z = { "238", "253" },
          bg = { "16", "254" },
          win = { "16", "254" },
          cwin = { "231", "31", "bold" },
        }
        vim.cmd("command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.config/tmux/tmuxline-light.conf") -- apply tmuxline settings and snapshot to file
      end
      set_tmuxline_theme()

      vim.api.nvim_create_autocmd("OptionSet", {
        group = vim.api.nvim_create_augroup("set_tmuxline_theme", { clear = true }),
        pattern = "background",
        callback = set_tmuxline_theme,
        desc = "set tmuxline theme",
      })

      vim.g["tmuxline_preset"] = {
        a = { "#S" }, -- session name |
        b = {
          table.concat({
            "#{cpu_fg_color}#{cpu_icon}#[fg=default]",
            "#{ram_fg_color}#{ram_icon}#[fg=default]",
            ("#{battery_color_charge_fg}#[bg=colour%s]#{battery_icon_charge}#{battery_color_status_fg}#[bg=colour%s]#{battery_icon_status}#[fg=default]"):format(
              vim.g.tmuxline_theme.b[2],
              vim.g.tmuxline_theme.b[2]
            ),
            -- .. "#{wifi_icon}",
          }, " "),
        },
        c = { "#(~/.support/tmux-docker-status.sh)" },
        win = { "#I", "#W#{?window_bell_flag, ,}#{?window_zoomed_flag, ,}" }, -- unselected tab
        cwin = { "#I", "#W#{?window_zoomed_flag, ,}" }, -- current tab
        x = { "#{?#{pomodoro_status},#{pomodoro_status},#(tmux show -gv @pomodoro_off)}" }, -- UTC time
        y = {
          "#(TZ=Etc/UTC date '+%%R UTC')",
          "%l:%M %p", -- local time
        },
        z = { "%a", "%b %d" }, -- local date
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- local navic_component = table.remove(opts.sections.lualine_c, #opts.sections.lualine_c)
      -- table.remove(opts.sections.lualine_c, #opts.sections.lualine_c) -- filename component
      local diagnostics_component = table.remove(opts.sections.lualine_c, 2)

      local git_diff_component = table.remove(opts.sections.lualine_x, 5)

      table.insert(opts.sections.lualine_c, 2, git_diff_component)
      table.insert(opts.sections.lualine_x, 5, diagnostics_component)

      opts.options.disabled_filetypes.winbar = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "lazy",
        "lspinfo",
        "starter",
      }

      -- opts.winbar = {
      --   lualine_b = {
      --     { "filename" },
      --   },
      --   lualine_c = {
      --     navic_component,
      --   },
      -- }

      opts.sections.lualine_y = {
        { "progress" },
      }

      opts.sections.lualine_z = {
        { "location" },
      }
    end,
  },
}
