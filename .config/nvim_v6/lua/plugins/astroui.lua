return {
  "AstroNvim/astroui",
  opts = {
    folding = {
      enabled = true,
      methods = { "treesitter", "lsp" , "indent" },
    },
    colorscheme = "ayu-dark",
    highlights = {
      -- ["ayu-dark"] = {
      --   LineNr = { fg = "#555555" },
      -- },
      init = {
        Visual = { bg = "#444444" },
        linenr = { link = "conceal" },
        -- linenr = { fg = "#555555" },
        -- SnacksPickerDir = { link = "Comment" },          -- or set a specific fg
        SnacksPickerDir = { link = "Conceal" },          -- or set a specific fg
        -- SnacksPickerDir = { link = "Directory" },          -- or set a specific fg
        -- SnacksPickerPathHidden = { fg = "#8a8a8a" },       -- was often linked to Comment
        -- SnacksPickerPathIgnored = { fg = "#8a8a8a" },
      }
    }
  }
}
