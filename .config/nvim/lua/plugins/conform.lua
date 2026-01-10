return {
  enabled = true,
  "stevearc/conform.nvim",
  -- opts = {},
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        -- markdown = { "markdownfmt" },
        -- Conform will run the first available formatter
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        python = { "black" },
      },
    })
    end
}
