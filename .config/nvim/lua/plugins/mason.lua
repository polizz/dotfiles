---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua-language-server",
        "clangd",
        "typescript-language-server",
        "basedpyright",
        "zls",
        "rust-analyzer",
        "marksman",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      PATH = "append",
    },
  },
}
