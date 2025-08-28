return {
  {
    "tomasky/bookmarks.nvim",
    -- after = "telescope.nvim",
    event = "VimEnter",
    config = function()
      require("bookmarks").setup({
        save_file = vim.fn.expand("$HOME/.bookmarks"), -- bookmarks save file path
        keywords = {
          ["@t"] = "☑️", -- mark annotation startswith @t ,signs this icon as `Todo`
          ["@w"] = "⚠️", -- mark annotation startswith @w ,signs this icon as `Warn`
          ["@f"] = "⛏", -- mark annotation startswith @f ,signs this icon as `Fix`
          ["@n"] = "", -- mark annotation startswith @n ,signs this icon as `Note`
        },
        on_attach = function(bufnr)
          local bm = require("bookmarks")
          local map = vim.keymap.set
          map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
          map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
          map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
          map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
          map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
          map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
          map("n", "mx", bm.bookmark_clear_all) -- removes all bookmarks
        end,
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzy-native.nvim" },
      {
        "nvim-telescope/telescope-frecency.nvim",
        opts = { -- there's no need to run config now opts do it by itself
          db_safe_mode = false, -- this somehow removes pretyped A in search
        },
      },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
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

        extensions = {
          frecency = {
            db_safe_mode = false,
          },
        },

        pickers = {
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
      })
    end,
  },
}
