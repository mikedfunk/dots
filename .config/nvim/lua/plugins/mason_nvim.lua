return {
  "williamboman/mason.nvim",
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "",
        package_pending = "",
        package_uninstalled = "󰅖",
      },
    },
    ensure_installed = {
      "cspell",
      "eslint_d",
      "php-cs-fixer",
      "sqlfluff",
    },
  },
}
