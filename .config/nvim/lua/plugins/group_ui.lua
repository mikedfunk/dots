local memoized_quote = nil

return {
  {
    "folke/snacks.nvim",
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
    opts_extend = {
      "dashboard.sections",
    },
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
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          function()
            if memoized_quote == nil then
              memoized_quote = table.concat(require("fortune").get_fortune(), "\n")
            end

            return {
              text = memoized_quote,
            }
          end,
        },
        preset = {
          header = table.concat({
            " ██████   █████                   █████   █████  ███                 ",
            "░░██████ ░░███                   ░░███   ░░███  ░░░                  ",
            " ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████  ",
            " ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███ ",
            " ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███ ",
            " ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███ ",
            " █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████",
            "░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░ ",
          }, "\n"),
        },
      },
    },
    -- init = function()
    --   vim.g.snacks_animate = false
    -- end,
  },
  {
    "saghen/blink.cmp",
    opts_extend = { "sources.default" },
    opts = {
      sources = {
        default = {
          "emoji",
          "nerdfont",
          "ripgrep",
          "dictionary",
          "cmp_jira",
        },
        providers = {
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            -- score_offset = 15,
            -- min_keyword_length = 2,
            opts = { insert = true }, -- Insert emoji (default) or complete its name
          },
          nerdfont = {
            name = "nerdfont",
            module = "blink.compat.source",
            score_offset = 10,
            opts = {},
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            async = true,
            max_items = 5,
            score_offset = -10,
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {},
          },
          dictionary = {
            name = "dictionary",
            module = "blink.compat.source",
            async = true,
            max_items = 5,
            min_keyword_length = 2,
            score_offset = -10,
            opts = {
              paths = { "/usr/share/dict/words" },
            },
          },
          tmux = {
            name = "tmux",
            module = "blink.compat.source",
            async = true,
            max_items = 5,
            score_offset = -10,
            opts = {},
          },
          cmp_jira = {
            name = "cmp_jira",
            module = "blink.compat.source",
            async = true,
            score_offset = 15,
            opts = {},
          },
        },
      },
      completion = {
        documentation = {
          window = {
            border = "rounded",
            winblend = 15,
          },
        },
        menu = {
          draw = { treesitter = { "lsp" } },
          border = "rounded",
          winblend = 15,
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winblend = 15,
        },
      },
    },
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "mikavilpas/blink-ripgrep.nvim",
      {
        "uga-rosa/cmp-dictionary",
        dependencies = { "saghen/blink.compat" },
      },
      {
        "chrisgrieser/cmp-nerdfont", -- trigger with :nf-
        dependencies = { "saghen/blink.compat" },
      },
      {
        "andersevenrud/cmp-tmux",
        branch = "main",
        dependencies = { "saghen/blink.compat" },
      },
      {
        -- change Jira authentication from oauth to basic auth (API key). Remove debug print.
        "mikedfunk/cmp-jira",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "saghen/blink.compat",
        },
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
          local color_mode = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light")
          local should_reload_tmux = vim.o.bg ~= "dark" and color_mode == "Dark\n"
            or vim.o.bg ~= "light" and color_mode == "Light"
          -- prevent this from running on startup if unnecessary
          if should_reload_tmux then
            -- plugins must be loaded after theme change or they stop working
            -- in statusbar, so source entire config
            vim.cmd("silent! !tmux source ~/.config/tmux/tmux.conf &")
          end
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
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "mfussenegger/nvim-lint",
      "monkoose/neocodeium",
      "stevearc/conform.nvim",
    },
    opts = function(_, opts)
      opts.options.disabled_filetypes.winbar = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "snacks_dashboard",
        "lazy",
        "lspinfo",
        "starter",
      }
      opts.sections.lualine_y = {
        { "progress" },
      }

      opts.sections.lualine_z = {
        { "location" },
      }

      -- nvim-lint and ale linters {{{
      ---@return string[]
      local function get_linters()
        local linters = { unpack(require("lint").linters_by_ft[vim.bo.ft] or {}) }
        for _, linter in ipairs(vim.g.ale_linters and vim.g.ale_linters[vim.bo.ft] or {}) do
          if not vim.tbl_contains(linters, linter) then
            table.insert(linters, linter)
          end
        end

        return linters
      end

      local nvim_lint_component = {
        ---@return string
        function()
          return " " .. tostring(#get_linters())
        end,
        color = function()
          return {
            fg = #get_linters() > 0 and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
            gui = "None",
          }
        end,
        cond = function()
          return package.loaded["lint"] ~= nil
        end,
        on_click = function()
          print(vim.inspect(get_linters()))
        end,
      }

      table.insert(opts.sections.lualine_x, nvim_lint_component)
      -- }}}

      -- neocodeium {{{
      local neocodeium_status_component = {
        LazyVim.config.icons.kinds.Codeium,
        color = function()
          local is_neocodeium_enabled = package.loaded["neocodeium"] and require("neocodeium").get_status() == 0
          return {
            fg = is_neocodeium_enabled and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
          }
        end,
        on_click = function()
          if package.loaded["neocodeium"] then
            vim.cmd("NeoCodeium toggle")
          end
        end,
        cond = function()
          return package.loaded["neocodeium"] ~= nil
        end,
      }

      table.insert(opts.sections.lualine_x, neocodeium_status_component)
      -- }}}

      -- conform.nvim and ale fixers {{{
      ---@return string[]
      local function get_formatters()
        ---@class OneFormatter
        ---@type OneFormatter[]
        local raw_enabled_formatters, _ = require("conform").list_formatters_to_run()
        ---@type string[]
        local formatters = {}

        for _, formatter in ipairs(raw_enabled_formatters) do
          table.insert(formatters, formatter.name)
        end

        ---@type string[]
        local ale_fixers = vim.g.ale_fixers and vim.g.ale_fixers[vim.bo.ft] or {}

        for _, formatter in ipairs(ale_fixers) do
          if not vim.tbl_contains(formatters, formatter) then
            table.insert(formatters, formatter)
          end
        end

        return formatters
      end

      local conform_nvim_component = {
        ---@return string
        function()
          return " " .. tostring(#get_formatters())
        end,
        color = function()
          return {
            fg = #get_formatters() > 0 and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
            gui = "None",
          }
        end,
        cond = function()
          return package.loaded["conform"] ~= nil
        end,
        on_click = function()
          vim.cmd("LazyFormatInfo")
        end,
      }

      table.insert(opts.sections.lualine_x, conform_nvim_component)
      -- }}}

      -- lsp clients {{{
      local get_lsp_client_names = function()
        local buf_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

        ---@type string[]
        local buf_client_names = {}

        for _, client in pairs(buf_clients) do
          table.insert(buf_client_names, client.name)
        end

        ---@type string[]
        buf_client_names = vim.fn.uniq(buf_client_names) ---@diagnostic disable-line missing-parameter
        return buf_client_names
      end

      local lsp_status_component = {
        ---@return string
        function()
          return "ʪ " .. tostring(#get_lsp_client_names())
        end,
        color = function()
          return {
            fg = #get_lsp_client_names() > 0 and Snacks.util.color("Normal") or Snacks.util.color("Comment"),
            gui = "None",
          }
        end,
        on_click = function()
          vim.cmd("LspInfo")
        end,
      }

      table.insert(opts.sections.lualine_x, lsp_status_component)
      -- }}}
    end,
  },
}
