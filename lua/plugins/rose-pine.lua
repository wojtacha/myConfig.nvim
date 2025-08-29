return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      --- @usage 'auto'|'main'|'moon'|'dawn'
      variant = "auto",
      -- --- @usage 'main'|'moon'|'dawn'
      dark_variant = "main",
      bold_vert_split = false,
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      dim_nc_background = true,
      disable_background = false,
      disable_float_background = true,
      disable_italics = false,
      --- @usage string hex value or named color from rosepinetheme.com/palette
      groups = {
        background = "base",
        background_nc = "_experimental_nc",
        panel = "surface",
        panel_nc = "base",
        border = "highlight_med",
        comment = "muted",
        link = "iris",
        punctuation = "subtle",

        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",

        headings = {
          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },
        -- or set all headings at once
        -- headings = 'subtle'
      },

      -- Change specific vim highlight groups
      -- https://github.com/rose-pine/neovim/wiki/Recipes
      highlight_groups = {
        ColorColumn = { bg = "rose" },
        QuickFixLine = { bg = "highlight_med", bold = true }, -- tweak to taste
        -- Blend colours against the "base" background
        -- CursorLine = { bg = "gold", blend = 80 },
        StatusLine = { fg = "love", bg = "love", blend = 10 },
        MiniJump2dSpot = { fg = "rose", bg = "highlight_med" },
        MiniJump2dSpotAhead = { fg = "rose", bg = "highlight_med" },
        MiniJump2dSpotUnique = { fg = "rose", bg = "highlight_high" },

        MiniDiffSignAdd = { fg = "#008000", bg = "#2a273f" },
        MiniDiffSignChange = { fg = "#0aa0FF", bg = "#2a273f" },
        MiniDiffSignDelete = { fg = "#FF4070", bg = "#2a273f" },
        MiniDiffOverAdd = { fg = "#FFC0CB", bg = "#2a273f" },
        MiniDiffOverChange = { fg = "#f6c177", bg = "#2a273f" },
        MiniDiffOverDelete = { fg = "#eb6f92", bg = "#2a273f" },
        MiniDiffOverContext = { fg = "#e0def4", bg = "#21202e" },
        MiniDiffOverContextBuf = { fg = "#6e6a86", bg = "#1f1d2e" },
        MiniDiffOverChangeBuf = { fg = "#FFFF77", bg = "#1f1d2e" },

        LspSignatureActiveParameter = { underline = true },
        -- By default each group adds to the existing config.
        -- If you only want to set what is written in this config exactly,
        -- you can set the inherit option:

        Search = { bg = "pine", inherit = false },
      },
    })
  end,
}
