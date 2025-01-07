return {
  {
    "folke/snacks.nvim",
    opts = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/animate.md#-animate
      animate = {
        -- speed up animations
        ---@class snacks.animate.Config
        {
          ---@type snacks.animate.Duration|number
          duration = 5, -- ms per step (default: 20)
          easing = "cubic", -- https://github.com/kikito/tween.lua#easing-functions
        },
      },
    },
    -- init = function()
    --   vim.g.snacks_animate = false
    -- end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = { window = { border = "rounded" } },
        menu = { border = "rounded" },
      },
    },
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
    dependencies = { "purarue/gitsigns-yadm.nvim" },
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
        "cmp",
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "snacks_dashboard",
        "harpoon",
        "lazy",
        "lspinfo",
        "starter",
      },
    },
  },
  {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle", "NeoZoom" },
    keys = {
      { "<C-w>z", "<cmd>NeoZoomToggle<cr>", noremap = true, desc = "Toggle Zoom" },
    },
    opts = {},
  },
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {
      ignore_filetypes = {
        "cmp",
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "snacks_dashboard",
        "lazy",
        "lspinfo",
        "starter",
      },
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
    "folke/noice.nvim",
    -- commit = "d9328ef903168b6f52385a751eb384ae7e906c6f", -- https://github.com/folke/noice.nvim/issues/921#issuecomment-2253363579
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
    "OXY2DEV/helpview.nvim",
    lazy = false, -- Recommended
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
