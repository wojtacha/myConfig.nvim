return {

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "openai",
        },
      },
      opts = {
        -- Set debug logging
        log_level = "DEBUG",
      },
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = "",
              },
            })
          end,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local linter = require("lint")

      local default_linter_set = {
        yaml = { "actionlint", "ansible_lint" },
        lua = { "selene" },
        ruby = { "rubocop" },
      }

      local linter_set = {}

      for ft, linters in pairs(default_linter_set) do
        linter_set[ft] = {} -- Initialize a table for each filetype
        for _, lntr in ipairs(linters) do
          if vim.fn.executable(lntr) == 1 then table.insert(linter_set[ft], lntr) end
        end
      end

      -- Assign the linters_by_ft
      linter.linters_by_ft = linter_set

      local lint = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint,
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}
