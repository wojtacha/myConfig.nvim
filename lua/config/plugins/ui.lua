return {
  {
    "nvim-lualine/lualine.nvim",
  },

  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      plugins = {
        registers = true,
      },
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 500,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      -- Document existing key chains
      -- spec = {
      --   { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      --   { '<leader>d', group = '[D]ocument' },
      --   { '<leader>r', group = '[R]ename' },
      --   { '<leader>s', group = '[S]earch' },
      --   { '<leader>w', group = '[W]orkspace' },
      --   { '<leader>t', group = '[T]oggle' },
      --   { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      -- },
    },
  },

  { "MunifTanjim/nui.nvim" },

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

  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require("nvim-web-devicons").set_icon({
        dart = {
          icon = " ",
          color = "#27A0E9",
          cterm_color = "65",
          name = "Dart",
        },
        ruby = {
          icon = " ",
          color = "#990008",
          cterm_color = "65",
          name = "Ruby",
        },
        gradle = {
          icon = " ",
          color = "#6EA711",
          cterm_color = "65",
          name = "Gradle",
        },
        go = {
          icon = "󰟓 ",
          color = "#2740E9",
          cterm_color = "65",
          name = "Go",
        },
        mod = {
          icon = "󰟓 ",
          color = "#911100",
          cterm_color = "65",
          name = "mod",
        },
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      {
        signs = true, -- show icons in the signs column
        sign_priority = 8, -- sign priority
        -- keywords recognized as todo comments
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "error" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
          PERF = { icon = " ", color = "warning", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = "", color = "hint", alt = { "INFO" } },
          TEST = { icon = "󰂖 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        gui_style = {
          fg = "NONE", -- The gui style to use for the fg highlight group.
          bg = "BOLD", -- The gui style to use for the bg highlight group.
        },
        merge_keywords = true, -- when true, custom keywords will be merged with the defaults
        -- highlighting of the line containing the todo comment
        -- * before: highlights before the keyword (typically comment characters)
        -- * keyword: highlights of the keyword
        -- * after: highlights after the keyword (todo text)
        --
        -- INFO:
        -- FIX:
        -- TODO:
        -- PERF:
        -- TEST:
        -- WARN:
        --  BUG:
        --  HACK:
        --  NOTE:
        --
        highlight = {
          multiline = true, -- enable multine todo comments
          multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
          multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
          before = "", -- "fg" or "bg" or empty
          keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
          after = "fg", -- "fg" or "bg" or empty
          pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
          comments_only = true, -- uses treesitter to match keywords in comments only
          max_line_len = 400, -- ignore lines longer than this
          exclude = {}, -- list of file types to exclude highlighting
        },
        -- list of named colors where we try to extract the guifg from the
        -- list of highlight groups or use the hex color if hl not found as a fallback
        colors = {
          error = { "#DC2626", "DiagnosticError", "ErrorMsg" },
          warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
          info = { "#DC2626", "DiagnosticInfo" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#FF00FF" },
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          -- regex that will be used to match keywords.
          -- don't replace the (KEYWORDS) placeholder
          -- pattern = [[\b(KEYWORDS):]], -- ripgrep regex
          pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
      },
    },
  },
}
