return {

  {
    "nvim-lualine/lualine.nvim",
  },

  -- { "MunifTanjim/nui.nvim" },

  {
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    config = function()
      require("dressing").setup({ -- Options go here. See :h dressing-options for more info.
        select = {
          get_config = function(opts)
            -- mason ui for serach
            if opts.kind == "mason.ui.language-filter" then return {
              backend = "telescope",
            } end
            if opts.kind == "filetyper" then
              return {
                backend = "fzf_lua",
                nui = {
                  max_width = 40,
                },
              }
            end
          end,
        },
      })
    end,
  },
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   event = "VeryLazy",
  --   config = function()
  --     require("nvim-web-devicons").set_icon({
  --       yml = {
  --         icon = "",
  --         color = "#FFB400",
  --         cterm_color = "65",
  --         name = "Yaml",
  --       },
  --       yaml = {
  --         icon = "",
  --         color = "#FFB400",
  --         cterm_color = "65",
  --         name = "Yaml",
  --       },
  --       dart = {
  --         icon = " ",
  --         color = "#27A0E9",
  --         cterm_color = "65",
  --         name = "Dart",
  --       },
  --       ruby = {
  --         icon = " ",
  --         color = "#990008",
  --         cterm_color = "65",
  --         name = "Ruby",
  --       },
  --       gradle = {
  --         icon = " ",
  --         color = "#6EA711",
  --         cterm_color = "65",
  --         name = "Gradle",
  --       },
  --       go = {
  --         icon = "󰟓 ",
  --         color = "#2740E9",
  --         cterm_color = "65",
  --         name = "Go",
  --       },
  --       mod = {
  --         icon = "󰟓 ",
  --         color = "#911100",
  --         cterm_color = "65",
  --         name = "mod",
  --       },
  --     })
  --   end,
  -- },
}
