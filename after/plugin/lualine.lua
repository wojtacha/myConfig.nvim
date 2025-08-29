local lualine = require("lualine")

local colors = {
  red = "#ee2b2a",
  light_blue = "#b4befe",
  lighter_blue = "#cdd6f4",
  grey = "#6c7086",
  black = "#1e1e2e",
  blacker = "#181825",
  dark = "#313244",
  white = "#fefefe",
  light_green = "#a6e3a1",
  yellow = "#ffda00",
  orange = "#fab387",
  green = "#00aa00",
  blue = "#80A7EA",
  jelly_blue = "#6F85B3",
  jelly_red = "#FF6347",
  jelly_deep_blue = "#000080",
  jelly_medium_blue = "#0070FF",
  jelly_green = "#89A159",
  jelly_pink = "#EB8DB4",
  jelly_purple = "#A172B5",
  jelly_yellow = "#FED93F",
  jelly_orange = "#F78E3D",
  material_blue = "#7097FF",
  material_green = "#B8E77B",
  material_pink = "#BA7CE5",
  material_orange = "#EB5A66",
}

local my_theme = {
  normal = {
    a = { fg = colors.blacker, bg = colors.jelly_blue },
    b = { fg = colors.white, bg = colors.dark },
    c = { fg = colors.white, bg = colors.black },
    z = { fg = colors.white, bg = colors.blue },
  },
  insert = { a = { fg = colors.black, bg = colors.jelly_green } },
  visual = { a = { fg = colors.black, bg = colors.jelly_purple } },
  replace = { a = { fg = colors.black, bg = colors.jelly_orange } },
  command = { a = { fg = colors.black, bg = colors.jelly_red } },
}

local space = {
  function() return " " end,
  -- color = { bg = colors.black, fg = colors.blue },
}

local filename = {
  "filename",
  -- color = { bg = colors.blue, fg = "#242735" },
  -- color = { fg = "#242735" },
  path = 1,
  separator = {
    -- left = "",
    -- right = "",
  },
}

local modes = {
  "mode",
  -- fmt = function(str) return str:sub(1, 1) end,
  -- color = { bg = function(str) end, fg = colors.black },
  separator = {
    -- left = "",
    -- right = "",
  },
}

local location = {
  "location",
  -- color = { bg = colors.blacker, fg = colors.white },
  -- separator = { left = "", right = "" },
}

local dia = {
  "diagnostics",
  -- color = { bg = colors.dark, fg = colors.white },
  -- separator = { left = "", right = "" },
}

local options = {
  options = {

    icons_enabled = true,
    -- theme = my_theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
    },
  },

  sections = {
    lualine_a = {
      modes,
      filename,
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {
      space,
      {
        -- color = { fg = colors.yellow },
      },
    },
    lualine_y = {},
    lualine_z = {
      dia,
      location,
      "lsp_status",
    },
  },
  extensions = { "quickfix", "fugitive", "oil", "nvim-tree" },
}

lualine.setup(options)
