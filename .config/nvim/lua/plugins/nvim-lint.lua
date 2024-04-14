return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      php = {
        "phpcs",
        "cspell",
      },
      javascript = {
        "eslint_d",
        "cspell",
      },
      sql = {
        "sqlfluff",
      },
    },
    linters = {
      phpcs = {
        -- This doesn't work because the parser expects stdin :/
        -- stdin = false,
        args = {
          "-q",
          "--report=json",
          "--cache",
          "--warning-severity=3",
          "-d",
          "memory_limit=100M",
          "-d",
          "xdebug.mode=off",
          "-",
        },
      },
    },
  },
}
