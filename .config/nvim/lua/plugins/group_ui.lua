return {
  -- {
  --   -- doesn't work. Tmux problem? https://github.com/soulis-1256/eagle.nvim/issues/17
  --   "soulis-1256/eagle.nvim",
  --   branch = "main",
  --   config = true,
  -- },
  -- { "SmiteshP/nvim-navic", opts = { separator = "  " } },
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
    "nvim-neo-tree/neo-tree.nvim",
    -- trying switching back to good old nerd-tree instead
    enabled = false,
    -- opts = { filesystem = { filtered_items = { hide_dotfiles = false } } },
  },
  -- Q: Why use nerd-tree instead of neo-tree?
  -- A: Neo-tree has a nasty bug where it won't focus on the current file in
  -- "large" directories. In my case it's all of them. My only workaround is to
  -- switch back to the buffer, then switch back to neo-tree. This is a pain
  -- when I'm in a right split. I also can't scroll right - it has this shitty
  -- right fade-out feature so I can't see the full file name. I also had bugs
  -- with nvim-tree, so I'm going old-school and using NERDTree for now. I also
  -- don't use the buffers or git sections of neo-tree.
  {
    "preservim/nerdtree",
    dependencies = {
      {
        "folke/edgy.nvim",
        opts = {
          left = {
            {
              ft = "nerdtree",
              title = "NerdTree",
              pinned = true,
              open = "NERDTreeFind",
            },
          },
        },
      },
      -- this shit is all too slow, I have a need for speed
      -- {
      --   "tiagofumo/vim-nerdtree-syntax-highlight",
      --   init = function()
      --     -- https://github.com/tiagofumo/vim-nerdtree-syntax-highlight?tab=readme-ov-file#mitigating-lag-issues
      --     -- vim.g.NERDTreeLimitedSyntax = 1
      --     vim.g.NERDTreeSyntaxDisableDefaultExtensions = 1
      --     vim.g.NERDTreeSyntaxDisableDefaultExactMatches = 1
      --     vim.g.NERDTreeSyntaxDisableDefaultPatternMatches = 1
      --     vim.g.NERDTreeSyntaxEnabledExtensions = { "c", "h", "c++", "cpp", "php", "rb", "js", "css", "html" } -- enabled extensions with default colors
      --     vim.g.NERDTreeSyntaxEnabledExactMatches = { "node_modules", "favicon.ico" } -- enabled exact matches with default colors
      --     vim.g.NERDTreeHighlightCursorline = 0
      --   end,
      -- },
      -- "ryanoasis/vim-devicons",
      -- {
      --   "Xuyuanp/nerdtree-git-plugin",
      --   init = function()
      --     vim.g.NERDTreeGitStatusConcealBrackets = 1
      --
      --     vim.g.NERDTreeGitStatusIndicatorMapCustom = {
      --       Modified = string.gsub(require("lazyvim.config").icons.git.modified, "%s+", ""),
      --       Staged = string.gsub(require("lazyvim.config").icons.git.added, "%s+", ""),
      --       Untracked = "󱃓",
      --       Renamed = "󰛂",
      --       Unmerged = "",
      --       Deleted = string.gsub(require("lazyvim.config").icons.git.removed, "%s+", ""),
      --       Dirty = "✎",
      --       Ignored = "◌",
      --       Clean = "✓",
      --       Unknown = "󱃓",
      --     }
      --   end,
      -- },
    },
    cmd = { "NERDTreeToggle", "NERDTreeFind", "NERDTreeFocus", "NERDTree" },
    keys = {
      {
        "<leader>e",
        function()
          -- this function is empty in the lua interface for some reason
          if vim.api.nvim_exec2("echo g:NERDTree.IsOpen()", { output = true }).output == "1" then
            vim.cmd("NERDTreeToggle")
          else
            vim.cmd("NERDTreeFind")
          end
        end,
        noremap = true,
        desc = "Toggle NERDTree",
      },
    },
    init = function()
      -- disable noice in nerdtree so I can use the menu
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nerdtree_no_noice", { clear = true }),
        pattern = "*",
        callback = function()
          local was_in_nerdtree = _G.is_in_nerdtree
          _G.is_in_nerdtree = vim.bo.filetype == "nerdtree"

          if _G.is_in_nerdtree then
            vim.cmd("NoiceDisable")
            -- require("noice.ui").disable()

            return
          end

          if was_in_nerdtree and not _G.is_in_nerdtree then
            vim.cmd("NoiceEnable")
            -- require("noice.ui").enable()
          end
        end,
        desc = "noice toggle for nerdtree",
      })
    end,
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
  { "folke/which-key.nvim", opts = { window = { border = "rounded" } } },
  { "LazyVim/LazyVim", opts = { ui = { border = "rounded" } } },
  {
    "folke/tokyonight.nvim",
    ---@type Config
    opts = {
      style = "night",
      lualine_bold = true, -- bold headers for each section header
      day_brightness = 0.15, -- high contrast but colorful

      -- jack up all saturation, default is too dull!
      on_colors = function(colors)
        local hsluv = require("tokyonight.hsluv")
        local multiplier = 1.6

        for k, v in pairs(colors) do
          if type(v) == "string" and v ~= "NONE" then
            local hsv = hsluv.hex_to_hsluv(v)
            hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
            colors[k] = hsluv.hsluv_to_hex(hsv)
          elseif type(v) == "table" then
            for kk, vv in pairs(v) do
              local hsv = hsluv.hex_to_rgb(vv)
              hsv[2] = hsv[2] * multiplier > 100 and 100 or hsv[2] * multiplier
              colors[k][kk] = hsluv.rgb_to_hex(hsv)
            end
          end
        end
      end,
    },
  },
  {
    "cormacrelf/dark-notify",
    config = function() -- can receive mode: "dark"|"light"
      require("dark_notify").run({
        onchange = function()
          vim.cmd("silent! !tmux source ~/.config/tmux/tmux.conf &")
        end,
      })
    end,
  },
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {
      ignore_filetypes = {
        "DressingInput",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "lazy",
        "lspinfo",
        "starter",
      },
    },
  },
  { "itchyny/vim-highlighturl", event = "VeryLazy" },
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
        },
      },
    },
    opts = {
      config = {
        footer = function()
          return require("fortune").get_fortune()
        end,
      },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "qf",
  },
  { "tzachar/highlight-undo.nvim", event = "VeryLazy", config = true },
  { "nvim-zh/colorful-winsep.nvim", event = "WinNew", config = true },
  -- { "brenoprata10/nvim-highlight-colors", opts = { enable_tailwind = true } },
  -- { "JosefLitos/colorizer.nvim", event = "VeryLazy", config = true },
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", opts = {} },
  {
    "luckasRanarison/tailwind-tools.nvim",
    ft = {
      "javascriptreact",
      "typescriptreact",
      "html",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ---@type TailwindTools.Option
    opts = {
      document_color = { kind = "background" }, -- or inline
      conceal = { enabled = true },
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
    -- this expects the extra lazyvim.plugins.extras.ui.mini-animate to be
    -- enabled in lazy.lua. It just tweaks the timing.
    "echasnovski/mini.animate",
    opts = function(_, opts)
      -- speed it up
      opts.resize.timing = require("mini.animate").gen_timing.cubic({ duration = 75, unit = "total" })
      opts.scroll.timing = require("mini.animate").gen_timing.cubic({ duration = 35, unit = "total" })
    end,
  },
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
  {
    "anuvyklack/fold-preview.nvim",
    event = "VeryLazy",
    opts = {
      auto = 400,
      border = "rounded",
      default_keybindings = false,
    },
  },
  {
    "smjonas/live-command.nvim",
    event = "VeryLazy",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
        },
      })
    end,
  },
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    },
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   dependencies = {
  --     {
  --       "eldritch-theme/eldritch.nvim",
  --       lazy = false,
  --       priority = 1000,
  --       opts = {},
  --     },
  --   },
  --   opts = {
  --     options = { theme = "eldritch" },
  --   },
  -- },
  {
    "haringsrob/nvim_context_vt",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      prefix = "↩ ",
    },
  },
  { "folke/edgy.nvim", opts = { animate = { cps = 200 } } }, -- speed up animation
  { "AstroNvim/astrocommunity", import = "astrocommunity.split-and-window.mini-map" },
  { "b0o/incline.nvim", opts = { hide = { only_win = true } } },
  {
    "LazyVim/LazyVim",
    -- dependencies = {
    --   "RRethy/base16-nvim",
    --   "eldritch-theme/eldritch.nvim",
    --   { "mawkler/modicator.nvim", dependencies = { "folke/tokyonight.nvim" }, opts = {} },
    -- },
    opts = { colorscheme = "tokyonight" },
  },
}
