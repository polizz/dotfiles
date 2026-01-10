return {
  enabled = true,
  'saghen/blink.cmp',
  opts = {
    completion = {
      menu = {
        draw = {
          columns = {
            -- { "label", "label_description" },
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" , gap = 1 },
            { "source_name", gap = 1}
          }
        }
      }
    },
    keymap = {
      preset = 'enter',
    },
    sources = {
      default = { 'lsp' },
      -- transform_items = function(_, items)
      --   return vim.tbl_filter(function(item)
      --     return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet and item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
      --   end, items)
      -- end,
      providers = {
        lsp = {
          score_offset = 5,
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet and item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
              -- return false
            end, items)
          end,
        },
        path = { score_offset = 3 },
        buffer = { score_offset = 0  },
        snippets = {
          score_offset = -10 ,
          -- transform_items = function(_, items)
          --   return vim.tbl_filter(function(item)
          --     -- vim.print ("Blink type: " .. item.kind)
          --     -- return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet and item.kind ~= require('blink.cmp.types').CompletionItemKind.Text
          --   end, items)
          -- end,
        },
      },
    },
    -- Disable cmdline
    cmdline = { enabled = false },
  },
}
