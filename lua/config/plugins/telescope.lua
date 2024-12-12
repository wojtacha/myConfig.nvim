return {
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    config = function()
      local actions = require "telescope.actions"
      require("telescope").setup {
        defaults = {
          sorting_strategy = "ascending",
          vimgrep_arguments = {
            "rg",
            "--hidden",
            "-g",
            "!node_modules/**",
            "-g",
            "!.git/**",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          path_display = { "smart" },
          file_ignore_patterns = { "^.git/" },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-n>"] = {
                actions.move_selection_next,
                type = "action",
                opts = { nowait = true, silent = true },
              },
              ["<C-d>"] = actions.delete_buffer,
              ["<C-p>"] = {
                actions.move_selection_previous,
                type = "action",
                opts = { nowait = true, silent = true },
              },
            },
            n = {
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
              ["<esc>"] = actions.close,
            },
          },
        },
        pickers = {
          frecency = {
            hidden = true,
            layout_strategy = "center",
            layout_config = {
              anchor = "N",
              width = 0.4,
              height = 0.6,
              prompt_position = "top",
            },
            previewer = false,
          },
          find_files = {
            hidden = true,
            layout_strategy = "center",
            layout_config = {
              anchor = "N",
              width = 0.4,
              height = 0.6,
              prompt_position = "top",
            },
            previewer = false,
          },
          live_grep = {
            hidden = true,
            theme = "ivy",
          },
          grep_string = {
            hidden = true,
            theme = "ivy",
          },
          buffers = {
            hidden = true,
            layout_strategy = "center",
            layout_config = {
              anchor = "N",
              width = 0.4,
              height = 0.6,
              prompt_position = "top",
            },
            previewer = false,
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function() require("telescope").load_extension "frecency" end,
  },
}
