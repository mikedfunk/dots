return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local navic_component = table.remove(opts.sections.lualine_c, #opts.sections.lualine_c)
    table.remove(opts.sections.lualine_c, #opts.sections.lualine_c) -- filename component
    local diagnostics_component = table.remove(opts.sections.lualine_c, 2)

    local git_diff_component = table.remove(opts.sections.lualine_x, 5)

    table.insert(opts.sections.lualine_c, 2, git_diff_component)
    table.insert(opts.sections.lualine_x, 5, diagnostics_component)

    opts.winbar = {
      lualine_b = {
        { "filename" },
      },
      lualine_c = {
        navic_component,
      },
    }

    opts.sections.lualine_y = {
      { "progress" },
    }

    opts.sections.lualine_z = {
      { "location" },
    }
  end,
}
