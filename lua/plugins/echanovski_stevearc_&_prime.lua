return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>h", function() require("harpoon"):list():add() end, desc = "add harpoon mark", noremap = true, mode = "n" },
      {
        "<C-e>",
        function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
        desc = "Toggle harpoon menu",
        noremap = true,
        mode = "n",
      },
      { "<C-l>", function() require("harpoon"):list():next() end, desc = "next Harpoon mark", noremap = false, mode = "n" },
      { "<C-h>", function() require("harpoon"):list():prev() end, desc = "next Harpoon mark", noremap = false, mode = "n" },
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      })
    end,
  },

  { "norcalli/nvim-colorizer.lua", cmd = { "ColorizerToggle" } }, -- shows colors in code which is cool!

  { "mbbill/undotree", keys = {
    { "<F2>", vim.cmd.UndotreeToggle, desc = "Toggle Undotree", mode = "n", noremap = true },
  } },
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      require("mini.icons").setup()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()
      require("mini.notify").setup({
        lsp_progress = {
          -- Whether to enable showing
          enable = true,

          -- Notification level
          level = "WARN",

          -- Duration (in ms) of how long last message should be shown
          duration_last = 700,
        },
      })

      require("mini.diff").setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      --   local statusline = require("mini.statusline")
      --   -- set use_icons to true if you have a Nerd Font
      --   statusline.setup({
      --     use_icons = true,
      --
      --     content = {
      --       active = function()
      --         local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      --         local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      --         local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
      --         local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      --         local location = MiniStatusline.section_location({ trunc_width = 75 })
      --         local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
      --         -- H.use_icons = nil
      --
      --         -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
      --         -- correct padding with spaces between groups (accounts for 'missing'
      --         -- sections, etc.)
      --         return MiniStatusline.combine_groups({
      --           { hl = mode_hl, strings = { mode } },
      --           "%<", -- Mark general truncate point
      --           { hl = "MiniStatuslineFilename", strings = { filename } },
      --           "%=", -- End left alignment
      --           { hl = mode_hl, strings = { diagnostics, lsp, search, location } },
      --         })
      --       end,
      --     },
      --   })
      --
      --   -- You can configure sections in the statusline by overriding their
      --   -- default behavior. For example, here we set the section for
      --   -- cursor location to LINE:COLUMN
      --   ---@diagnostic disable-next-line: duplicate-set-field
      --   statusline.section_location = function() return "%2l:%-2v" end
      --
      --   -- ... and there is more!
      --   --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-mini/mini.icons",
    },
    config = function()
      require("mini.icons").mock_nvim_web_devicons()
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc) return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true } end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)
        -- custom mappings

        vim.keymap.del("n", "<C-e>", { buffer = bufnr })
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end

      require("nvim-tree").setup({ on_attach = my_on_attach, filters = {
        git_ignored = false,
      } })
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
        python = { "ruff" },
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
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {},
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format", "ruff_fix" }
          else
            return { "isort", "black" }
          end
        end,
        -- go = { "golangci-lint", "gofmt" },
        lua = { "stylua" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        terraform = { "tofu_fmt" },
        yaml = { "yamlfmt" },
        json = { "fixjson" },
        nix = { "alejandra" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,

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
    "stevearc/oil.nvim",
    opts = {},
    dependencies = {
      "nvim-mini/mini.icons",
    },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,
        -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = true,
        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        -- (:help prompt_save_on_select_new_entry)
        prompt_save_on_select_new_entry = true,
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        view_options = {
          show_hidden = true,
        },
        use_default_keymaps = false,
        keymaps = {
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["."] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["H"] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      })
    end,
  },
}
