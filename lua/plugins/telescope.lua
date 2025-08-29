return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    dependencies = { "nvim-mini/mini.icons" },
    opts = {},
    keys = {
      {
        "<leader>ff",
        function()
          FzfLua.files({
            resume = true,
            winopts = {
              height = 0.6, -- window height
              width = 0.5, -- window width
              row = 1, -- window row position (0=top, 1=bottom)
              col = 0.50, -- window col position (0=left, 1=right)
              border = "double", -- none, single, double, rounded, solid, shadow
              backdrop = 70,
              preview = { hidden = true },
            },
          })
        end,
        desc = "[F]ind [f]iles",
        mode = "n",
      },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "[F]ind [R]ecently opened files" },
      --     { "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "[F]ind [C]ommands" },
      { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "[F]ind [M]arks" },
      --     -- { "<leader>fs", "<cmd>FzfLua grep_cword<cr>", desc = "[F]ind current [S]ymbol under cursor" },
      --     -- { "<leader>fS", "<cmd>FzfLua grep_cword_visual<cr>", desc = "[F]ind current [S]ymbol under cursor (visual)" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzy-native.nvim", config = function() require("telescope").load_extension("fzy_native") end },
      {
        "nvim-telescope/telescope-frecency.nvim",
        opts = { -- there's no need to run config now opts do it by itself
          db_safe_mode = false, -- this somehow removes pretyped A in search
        },
      },
      {
        "mrloop/telescope-git-branch.nvim",
      },
    },
    keys = {
      { "<leader>fw", require("telescope.builtin").grep_string, desc = "[F]ind [w]ord", mode = "n" },
      { "<leader>fs", require("telescope.builtin").live_grep, desc = "[F]ile [s]earch - inside live grep", mode = "n" },
      {
        "<leader>fo",
        function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") }) end,
        desc = "[F]ind [o]ccurence of word under cursor",
        mode = "n",
      },
      {
        "<leader>fo",
        function()
          local selection = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })[1]
          require("telescope.builtin").grep_string({ search = selection })
        end,
        desc = "[F]ind [o]ccurence of selected word",
        mode = "x",
      },
      { "<leader>fb", require("telescope.builtin").buffers, desc = "[F]ind open [b]uffers", mode = "n" },
      { "<leader>fh", require("telescope.builtin").help_tags, desc = "[F]ind [h]elp", mode = "n" },
      { "<leader><leader>", "<cmd>Telescope commands<cr>", desc = "Toggle Commands Explorer", mode = "n" },

      {
        "<leader>fg",
        function()
          require("telescope").load_extension("git_branch")
          require("git_branch").files()
        end,
        desc = "[F]ind [h]elp",
        mode = "n",
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
