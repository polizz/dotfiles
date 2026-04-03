return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local harpoon = require("harpoon")
      harpoon:setup()

      local theme_toggle = require("theme_toggle").init()

      _G.qrz = require("qrz")
      _G.visual_bc = require("visual_bc")

      local astro = require("astrocore")
      local mappings = {}
      local Snacks = require("snacks")

      mappings = {
        mappings = {
          v = {
            ["<Leader>bb"] = { function() _G.visual_bc.calc()  end, desc = "Visual BC Calculate" },
          },
          i = {
            ["kj"] = { "<ESC>", desc = "Escape" },
          },
          n = {
            ["<Leader>a"] = { function() harpoon:list():add() end, desc = "Harpoon Add" },
            ["<Leader>r"] = { function() harpoon:list():remove() end, desc = "Harpoon Remove"  },
            ["<C-F>"] = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon List"  },
            ["<C-J>"] = { function() harpoon:list():select(1) end, desc = "Harpoon File 1" },
            ["<C-K>"] = { function() harpoon:list():select(2) end, desc = "Harpoon File 2" },
            ["<C-L>"] = { function() harpoon:list():select(3) end, desc = "Harpoon File 3"  },
            ["<C-I>"] = { function() harpoon:list():select(4) end, desc = "Harpoon File 4"  },
            -- ["<C-[>"] = { function() harpoon:list():prev() end, desc = "Harpoon Prev"   },
            -- ["<C-]>"] = { function() harpoon:list():next() end, desc = "Harpoon Next"   },
            ["<Leader>qq"] = { function() _G.qrz.lookup() end, desc = "QRZ callsign lookup" },
            ["<Leader>fg"] = { function() Snacks.picker.grep() end, desc = "Live Grep"  },
            ["<Leader>ff"] = { function() Snacks.picker.files() end, desc = "Find Files" },
            ["<Leader>fs"] = { function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            ["<Leader><space>"] = { function() Snacks.picker.smart() end, desc = "Smart Find Files" },
            gR = { function() Snacks.picker.lsp_references() end, desc = "LSP References"},
            ["<Leader>b"] = { name = "Buffers" },
            ["<Leader>w"] = { ":w!<cr>", desc = "Save File" },
            ["<Leader>ub"] = { function() theme_toggle.toggle() end, desc = "Toggle background" },
          }
        }
      }

      return astro.extend_tbl(opts, mappings)
    end
  },
  -- {
  --   "AstroNvim/astrolsp",
  --   ---@type AstroLSPOpts
  --   opts = {
  --     mappings = {
  --       n = {
  --         -- this mapping will only be set in buffers with an LSP attached
  --         -- condition for only server with declaration capabilities
  --         gdd = {
  --           function()
  --             vim.lsp.buf.definition()
  --           end,
  --           desc = "Show Declaration of current symbol in-place",
  --           cond = "textDocument/declaration",
  --         },
  --       },
  --     },
  --   },
  -- },
}

