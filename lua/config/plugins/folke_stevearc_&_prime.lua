return {
  { "folke/neoconf.nvim", cmd = "Neoconf" },

  {
    "folke/neodev.nvim",
    config = function() require("neodev").setup {} end,
  },

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      }
    end,
  },

  { "norcalli/nvim-colorizer.lua", event = "VeryLazy" }, -- shows colors in code which is cool!

  { "tpope/vim-surround" }, -- ale wierze w papieża

  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup {} end }, -- when you press "{" sign "}" appears automagically

  { "mbbill/undotree", event = "VeryLazy" },

  { "vimwiki/vimwiki", event = "VeryLazy" }, -- good plugin for notes cheatsheet diary todo

  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
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
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },
}
