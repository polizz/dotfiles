return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      ensure_installed = {
        "lua",
        "vim",
        "json",
        "rust",
        "markdown",
        "markdown_inline",
        "hurl",
        "yaml"
      },
    },
  }
}
