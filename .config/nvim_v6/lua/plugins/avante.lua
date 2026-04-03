return {
  "yetone/avante.nvim",
  enabled = false,
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- {
    --   -- support for image pasting
    --   "HakonHarnes/img-clip.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     -- recommended settings
    --     default = {
    --       embed_image_as_base64 = false,
    --       prompt_for_file_name = false,
    --       drag_and_drop = {
    --         insert_mode = true,
    --       },
    --       -- required for Windows users
    --       use_absolute_path = true,
    --     },
    --   },
    -- },
  },
  -- opts = {
  --   vendors = {
  --     provider = "deepseek_coder", -- Recommend using Claude
  --     deepseek_coder = {
  --       __inherited_from = "openai",
  --       api_key_name = "DEEPSEEK_CODER_API_KEY",
  --       endpoint = "https://api.deepseek.com",
  --       model = "deepseek-coder",
  --       temperature = 0,
  --       max_tokens = 8192,
  --     },
  --     -- deepseek_chat = {
  --     --   __inherited_from = "openai",
  --     --   endpoint = "https://api.deepseek.com",
  --     --   model = "deepseek-chat",
  --     --   temperature = 0,
  --     --   max_tokens = 8192,
  --     -- },
  --   },
  -- },
  ft = { "markdown", "Avante" },
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  config = function()
    require("avante").setup({
      providers = {
        provider = "gemini_pro_25_pro_06_05", -- Recommend using Claude
        claude_sonnet_4 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "anthropic/claude-sonnet-4",
          extra_request_body = {
            temperature = 0,
          },
          max_tokens = 200000,
        },
        o3 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "openai/o3",
          max_tokens = 1000000,
        },
        o3_mini_high = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "openai/o3-mini-high",
          max_tokens = 1000000,
        },
        gpt_41 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "openai/gpt-4.1",
          max_tokens = 1000000,
        },
        gpt_41_mini = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "openai/gpt-4.1-mini",
          max_tokens = 1000000,
        },
        gemini_pro_25_pro_06_05 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "google/gemini-2.5-pro-preview",
          max_tokens = 1000000,
        },
        gemini_pro_25_pro_05_06 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "google/gemini-2.5-pro-preview-05-06",
          max_tokens = 1000000,
        },
        deepseek_r1 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "deepseek/deepseek-r1",
          max_tokens = 8192,
          disable_tools = true,
          extra_request_body = {
            temperature = 0,
            provider= {
              order= {
                "DeepSeek",
                "Together",
                "Fireworks"
              }
            }
          },
        },
        deepseek_v3 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "deepseek/deepseek-chat",
          max_tokens = 8192,
          disable_tools = true,
          extra_request_body = {
            temperature = 0,
            provider= {
              order= {
                "DeepSeek",
                "Together",
                "Fireworks"
              }
            }
          },
        },
        claude_sonnet_37 = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1/",
          model = "anthropic/claude-3.7-sonnet:beta",
          extra_request_body = {
            temperature = 0,
          },
          max_tokens = 8192,
        },
      },
      -- auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
      ---Specify the special dual_boost mode
      ---1. enabled: Whether to enable dual_boost mode. Default to false.
      ---2. first_provider: The first provider to generate response. Default to "openai".
      ---3. second_provider: The second provider to generate response. Default to "claude".
      ---4. prompt: The prompt to generate response based on the two reference outputs.
      ---5. timeout: Timeout in milliseconds. Default to 60000.
      ---How it works:
      --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
      ---Note: This is an experimental feature and may not work as expected.
      -- dual_boost = {
      --   enabled = false,
      --   first_provider = "openai",
      --   second_provider = "claude",
      --   prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
      --   timeout = 60000, -- Timeout in milliseconds
      -- },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = "center", -- left, center, right for title
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          border = "rounded",
          start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = true, -- Start insert mode when opening the ask window
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "ours", -- which diff to focus after applying
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
        --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --- Disable by setting to -1.
        override_timeoutlen = 500,
      },
  })
  end
}
