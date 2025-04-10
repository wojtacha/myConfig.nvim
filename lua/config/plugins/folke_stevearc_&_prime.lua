return {
  { "folke/neoconf.nvim", cmd = "Neoconf" },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
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

  { "norcalli/nvim-colorizer.lua", event = "VeryLazy" }, -- shows colors in code which is cool!

  { "mbbill/undotree", event = "VeryLazy" },

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
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

  { "vimwiki/vimwiki", event = "VeryLazy" }, -- good plugin for notes cheatsheet diary todo
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
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
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
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

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
}
