return {
  {
    "olimorris/codecompanion.nvim",
    version = "v17.31.0",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "j-hui/fidget.nvim",
    },
    keys = {
      { "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Code Companion Chat", mode = "n" },
      { "<LocalLeader>a", "<cmd>CodeCompanionChat Add<cr>", desc = "Prompt for visual selection", mode = "v" },
    },

    config = function()
      local adapters = require("internal.codecompanion").adapters
      require("codecompanion").setup({
        adapters = {
          http = {
            anthropic = adapters.anthropic(),
            portkey = adapters.portkey(),
          },
        },
        strategies = {
          chat = {
            adapter = {
              name = "portkey",
              model = "@claude-codegen-poc/claude-sonnet-4-5-20250929",
            },
            --   inline = {
            --     adapter = {
            --       name = "portkey",
            --       model = "@daba-dev-bedrock-us-east-2/us.anthropic.claude-3-5-haiku-20241022-v1:0",
            --     },
            --   },
            --   cmd = {
            --     adapter = {
            --       name = "portkey",
            --       model = "@daba-dev-bedrock-us-east-2/us.anthropic.claude-sonnet-4-20250514-v1:0",
            --     },
            --   },
          },
        },
      })
    end,
  },
  --     roles = {
  --       user = "wojtacha",
  --     },
  --     keymaps = {
  --       send = {
  --         modes = {
  --           i = { "<C-CR>", "<C-s>" },
  --         },
  --       },
  --       completion = {
  --         modes = {
  --           i = "<C-x>",
  --         },
  --       },
  --     },
  --     -- slash_commands = {
  --     --   ["buffer"] = {
  --     --     keymaps = {
  --     --       modes = {
  --     --         i = "<C-b>",
  --     --       },
  --     --     },
  --     --     opts = {
  --     --       provider = "snacks",
  --     --     },
  --     --   },
  --     --   ["fetch"] = {
  --     --     keymaps = {
  --     --       modes = {
  --     --         i = "<C-f>",
  --     --       },
  --     --     },
  --     --   },
  --     --   ["file"] = {
  --     --     opts = {
  --     --       provider = "snacks",
  --     --     },
  --     --   },
  --     --   ["help"] = {
  --     --     opts = {
  --     --       provider = "snacks",
  --     --       max_lines = 1000,
  --     --     },
  --     --   },
  --     --   ["image"] = {
  --     --     keymaps = {
  --     --       modes = {
  --     --         i = "<C-i>",
  --     --       },
  --     --     },
  --     --     opts = {
  --     --       dirs = { "~/Documents/Screenshots" },
  --     --     },
  --     --   },
  --     -- },
  --   },
  -- inline = {
  --   adapter = {
  --     name = "anthropic",
  --     model = "claude-sonnet-4-20250514",
  --   },
  -- },
  -- },
}
