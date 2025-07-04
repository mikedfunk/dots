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
    init = function()
      vim.g.snacks_animate = false
    end,
    ---@type snacks.Config
    opts = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/animate.md#-animate
      animate = {
        -- speed up animations
        {
          duration = 5, -- ms per step (default: 20)
          easing = "cubic", -- https://github.com/kikito/tween.lua#easing-functions
        },
      },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
      styles = {
        zen = {
          backdrop = {
            transparent = false,
          },
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
      notifier = {
        timeout = 5000,
      },
    },
    -- init = function()
    --   vim.g.snacks_animate = false
    -- end,
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
          -- plugins must be loaded after theme change or they stop working
          -- in statusbar, so source entire config
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
  -- TODO: breaks my terminal due to some problem with character width
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts_extend = { "excluded_filetypes" },
    opts = {
      handlers = { gitsigns = true },
      -- handle = {
      --   highlight = "PmenuSel",
      -- },
      excluded_filetypes = {
        "Avante",
        "AvanteInput",
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "cmp",
        "dashboard",
        "harpoon",
        "lazy",
        "lspinfo",
        "mason",
        "noice",
        "snacks_dashboard",
        "snacks_picker_input",
        "starter",
      },
    },
  },
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {
      ignore = {
        "Avante",
        "AvanteInput",
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "cmp",
        "dashboard",
        "lazy",
        "lspinfo",
        "mason",
        "snacks_dashboard",
        "snacks_picker_input",
        "starter",
      },
    },
  },
  -- Top right filename float. This is really helpful but it overlaps a lot of stuff and starts to become a nuisance.
  -- {
  --   "b0o/incline.nvim",
  --   opts = {
  --     hide = { only_win = true },
  --     window = { winhighlight = { active = { Normal = "CursorLineSign" } } },
  --   },
  -- },
  {
    "folke/noice.nvim",
    -- commit = "d9328ef903168b6f52385a751eb384ae7e906c6f", -- https://github.com/folke/noice.nvim/issues/921#issuecomment-2253363579
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      ---@type NoiceConfigViews
      -- views = {
      --   notify = {
      --     backend = "notify_send",
      --   },
      -- },
      -- https://github.com/folke/noice.nvim/discussions/364
      routes = {
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
        -- lua_ls has a bunch of noisy messages
        {
          filter = { event = "lsp", find = "Searching in files..." },
          opts = { skip = true },
        },
        {
          filter = { event = "lsp", find = "Processing file symbols..." },
          opts = { skip = true },
        },
        {
          filter = { event = "lsp", find = "Loading workspace" },
          opts = { skip = true },
        },
        {
          filter = { event = "lsp", find = "Diagnosing" },
          opts = { skip = true },
        },
        -- so does snyk_ls
        {
          filter = { event = "lsp", find = "snyk" },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "edkolev/tmuxline.vim",
    init = function()
      local function set_tmuxline_theme()
        -- 256 colors. Print all available colors: `curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash`
        -- values represent: { FG, BG, ?ATTR }
        --   FG ang BG are color codes
        --   ATTR (optional) is a comma-delimited string of one or more of bold, dim, underscore, etc. For details refer to the STYLE section in the tmux man page
        if vim.o.background == "dark" then
          -- dark 256 colors only
          -- vim.g["tmuxline_theme"] = {
          --   a = { "16", "254", "bold" }, -- left-most statusline section
          --   b = { "247", "236" }, -- one away from left-most statusline section
          --   c = { "250", "233" }, -- two away from left-most statusline section
          --
          --   x = { "250", "233" }, -- right-most statusline section
          --   y = { "247", "236" }, -- one away from right-most statusline section
          --   z = { "235", "252" }, -- right-most statusline section
          --
          --   bg = { "247", "234" }, -- statusline background between sections
          --   win = { "250", "234" }, -- unselected "tab" aka window in tmux
          --   ["win.dim"] = { "244", "234" },
          --   cwin = { "231", "31", "bold" }, -- selected "tab" aka window in tmux
          --   ["cwin.dim"] = { "117", "31" },
          -- }

          -- dark 16 colors + 256 colors mix
          vim.g["tmuxline_theme"] = {
            a = { "15", "0", "bold" }, -- left-most statusline section
            b = { "247", "236" }, -- one away from left-most statusline section
            c = { "248", "237" }, -- two away from left-most statusline section

            z = { "15", "0", "bold" }, -- right-most statusline section
            y = { "247", "236" }, -- one away from right-most statusline section
            x = { "248", "237" }, -- two away from right-most statusline section

            bg = { "247", "235" }, -- statusline background between sections
            win = { "7", "235" }, -- unselected "tab" aka window in tmux
            cwin = { "0", "14", "bold" }, -- selected "tab" aka window in tmux
            ["win.dim"] = { "244", "235" },
            ["cwin.dim"] = { "117", "14", "bold" },
          }
          vim.cmd("command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.config/tmux/tmuxline-dark.conf") -- apply tmuxline settings and snapshot to file

          return
        end

        -- light 256 colors version
        -- vim.g["tmuxline_theme"] = {
        --   a = { "238", "253", "bold" }, -- left-most statusline section
        --   b = { "255", "238" }, -- one away from left-most statusline section
        --   c = { "255", "236" }, -- two away from left-most statusline section
        --
        --   z = { "238", "253" }, -- right-most statusline section
        --   y = { "255", "238" }, -- one away from right-most statusline section
        --   x = { "255", "236" }, -- right-most statusline section
        --
        --   bg = { "16", "254" }, -- statusline background between sections
        --   win = { "16", "254" }, -- unselected "tab" aka window in tmux
        --   cwin = { "231", "31", "bold" }, -- selected "tab" aka window in tmux
        -- }
        -- light 16 colors + 256 colors version
        vim.g["tmuxline_theme"] = {
          a = { "0", "15", "bold" }, -- left-most statusline section
          b = { "254", "238" }, -- one away from left-most statusline section
          c = { "255", "239" }, -- two away from left-most statusline section

          z = { "0", "15", "bold" }, -- right-most statusline section
          y = { "254", "238" }, -- one away from right-most statusline section
          x = { "255", "239" }, -- two away from right-most statusline section

          bg = { "16", "0" }, -- statusline background between sections
          win = { "16", "0" }, -- unselected "tab" aka window in tmux
          cwin = { "231", "14", "bold" }, -- selected "tab" aka window in tmux
        }
        vim.cmd("command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.config/tmux/tmuxline-light.conf") -- apply tmuxline settings or snapshot to file
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
        x = {
          "#(~/.support/tmux-spotify-status.sh)",
          "#{?#{pomodoro_status},#{pomodoro_status},#(tmux show -gv @pomodoro_off)}",
        },
        y = {
          "#(TZ=Etc/UTC date '+%%R UTC')", -- UTC time
          "%l:%M %p", -- local time
        },
        z = { "%a", "%b %d" }, -- local date
      }
    end,
  },
  {
    "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "mason-org/mason.nvim",
    -- url = "https://github.com/iguanacucumber/mason.nvim", -- temporary fork see https://old.reddit.com/r/neovim/comments/1k1jtlm/made_a_small_fork_of_masonnvim_a_bit_like_what_i/
    opts_extend = { "registries" },
    opts = {
      ui = { border = "rounded" },
      registries = {
        "file:~/.config/nvim/lua/mason_registry/zk",
        "github:mason-org/mason-registry",
      },
    },
  },
  -- this is installed via extras and customized here (TODO: override still not working. Needs config in the lualine segment which is harder to do.)
  -- {
  --   "SmiteshP/nvim-navic",
  --   config = function(_, opts) -- lazyvim force overrides opts, so gotta do the same :/
  --     opts.separator = "  "
  --     require("nvim-navic").setup(opts)
  --   end,
  -- },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "mfussenegger/nvim-lint",
      -- "monkoose/neocodeium",
      "stevearc/conform.nvim",
    },
    opts = function(_, opts)
      opts.options.disabled_filetypes.winbar = {
        "Avante",
        "AvanteInput",
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "cmp",
        "dashboard",
        "lazy",
        "lspinfo",
        "mason",
        "snacks_dashboard",
        "snacks_picker_input",
        "starter",
      }

      opts.options.disabled_filetypes.statusline = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "lazy",
        "lspinfo",
        "mason",
        "snacks_dashboard",
        "snacks_picker_input",
        "starter",
      }

      opts.sections.lualine_y = {
        { "progress" },
      }

      opts.sections.lualine_z = {
        { "location" },
      }

      -- neocodeium {{{
      local neocodeium_status_component = {
        function()
          return LazyVim.config.icons.kinds.Codeium:gsub("%s+", "")
        end,
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

      -- minuet-ai {{{
      if package.loaded["minuet"] then
        table.insert(opts.sections.lualine_x, require("minuet.lualine"))
      end
      -- }}}

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

      -- conform.nvim and ale fixers {{{
      ---@return string[]
      local function get_formatters()
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
  {
    "kevinhwang91/nvim-bqf",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "qf",
  },
  { "stevearc/quicker.nvim", ft = "qf", opts = {} },
  {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle", "NeoZoom" },
    keys = {
      { "<C-w>z", "<cmd>NeoZoomToggle<cr>", noremap = true, desc = "Toggle Zoom" },
    },
    opts = {},
  },
  -- {
  --   "mcauley-penney/visual-whitespace.nvim",
  --   opts = {},
  --   keys = { "v", "V", "<C-v>" },
  -- },
  -- doesn't work :/
  -- {
  --   "soemre/commentless.nvim",
  --   opts = {},
  --   keys = {
  --     {
  --       "<leader>C",
  --       function()
  --         require("commentless").toggle()
  --       end,
  --       desc = "Toggle Comments",
  --     },
  --   },
  -- },
}
