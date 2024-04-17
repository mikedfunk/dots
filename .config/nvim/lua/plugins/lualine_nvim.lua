return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local diagnostics_component = opts.sections.lualine_c[2]
    table.remove(opts.sections.lualine_c, 2)
    local git_diff_component = opts.sections.lualine_x[5]
    table.remove(opts.sections.lualine_x, 5)

    table.insert(opts.sections.lualine_c, 2, git_diff_component)
    table.insert(opts.sections.lualine_x, 5, diagnostics_component)

    opts.sections.lualine_y = {
      { "progress" },
    }

    opts.sections.lualine_z = {
      { "location" },
    }
  end,
}
