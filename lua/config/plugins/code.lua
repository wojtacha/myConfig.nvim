return {
  -- TODO:  check if cmp needs to be there  and remove lsp zero
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required

      {                            -- Optional
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup {
            ui = {
              border = "double",
              icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
              },
            },
          }
        end,
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional
      -- Autocompletion
      --
      { "hrsh7th/nvim-cmp" },
      -- Required
      { "hrsh7th/cmp-nvim-lsp" },         -- Required
      { "hrsh7th/cmp-buffer" },           -- Optional
      { "hrsh7th/cmp-path" },             -- Optional
      { "saadparwaiz1/cmp_luasnip" },     -- Optional
      { "hrsh7th/cmp-nvim-lua" },         -- Optional
      -- Snippets
      { "L3MON4D3/LuaSnip" },             -- Required
      { "rafamadriz/friendly-snippets" }, -- Optional
    },
  },

  {
    "ray-x/lsp_signature.nvim", -- Show function signature when you type
    event = "VeryLazy",
    config = function() require("lsp_signature").setup() end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local linter = require "lint"

      local default_linter_set = {
        yaml = { "actionlint", "ansible_lint" },
        lua = { "selene" },
        ruby = { "rubocop" },
      }

      local linter_set = {}

      for ft, linters in pairs(default_linter_set) do
        linter_set[ft] = {} -- Initialize a table for each filetype
        for _, lntr in ipairs(linters) do
          if vim.fn.executable(lntr) == 1 then
            table.insert(linter_set[ft], lntr)
          end
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

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        -- typescript = { "biome", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "yamlfmt" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500 },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    "sourcegraph/sg.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function() require("sg").setup {} end,
  },

  {
    "nomnivore/ollama.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
    keys = {
      -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oo",
        function() require("ollama").prompt() end,
        desc = "ollama prompt",
        mode = { "n", "v" },
      },
      -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oG",
        function() require("ollama").prompt "Generate_Code" end,
        desc = "ollama Generate Code",
        mode = { "n", "v" },
      },
    },

    ---@type Ollama.Config
    opts = {
      model = "mistral",
      url = "http://127.0.0.1:11434",
      -- prompts = require "ollama.prompts",
      serve = {
        on_start = false,
        command = "ollama",
        args = { "serve" },
        stop_command = "pkill",
        stop_args = { "-SIGTERM", "ollama" },
      },
    },
    prompts = {
      Sample_Prompt = {
        prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
        input_label = "> ",
        model = "mistral",
        action = "display",
      },
    },
  },
}
