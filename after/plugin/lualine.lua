local function table_concat(tab, seperator)
  if seperator == nil then return table.concat(tab) end
  local buffer = {}
  for i, v in ipairs(tab) do
    buffer[#buffer + 1] = v
    if i < #tab then buffer[#buffer + 1] = seperator end
  end
  return table.concat(buffer)
end

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
  jelly_yellow = "#FED93F",
  jelly_orange = "#C25539",
  material_blue = "#7097FF",
  material_green = "#B8E77B",
  material_pink = "#BA7CE5",
  material_orange = "#EB5A66",
}

local theme = {
  normal = {
    a = { fg = colors.blacker, bg = colors.blue },
    b = { fg = colors.white, bg = colors.dark },
    c = { fg = colors.white, bg = colors.black },
    z = { fg = colors.white, bg = colors.blue },
  },
  insert = { a = { fg = colors.black, bg = colors.jelly_green } },
  visual = { a = { fg = colors.black, bg = colors.jelly_medium_blue } },
  replace = { a = { fg = colors.black, bg = colors.jelly_orange } },
  command = { a = { fg = colors.black, bg = colors.jelly_red } },
}

local vim_icons = {
  function() return "" end,
  separator = { left = "", right = "" },
  color = { bg = colors.blacker, fg = colors.white },
}

local space = {
  function() return " " end,
  color = { bg = colors.black, fg = colors.blue },
}

local filename = {
  "filename",
  color = { bg = colors.blue, fg = "#242735" },
  separator = {
    -- left = "",
    right = "",
  },
}

local filetype = {
  "filetype",
  icon_only = true,
  colored = true,
  color = { bg = colors.dark },
  separator = { left = "", right = "" },
}

-- local filetype_tab = {
--   "filetype",
--   icon_only = true,
--   colored = true,
--   color = { bg = colors.white },
-- }
--
-- local buffer = {
--   require("tabline").tabline_buffers,
--   separator = { left = "", right = "" },
-- }
--
-- local tabs = {
--   require("tabline").tabline_tabs,
--   separator = { left = "", right = "" },
-- }

local fileformat = {
  "fileformat",
  color = { bg = colors.lighter_blue, fg = colors.dark },
  separator = { left = "", right = "" },
}

local encoding = {
  "encoding",
  color = { bg = colors.dark, fg = colors.blue },
  separator = { left = "", right = "" },
}

local branch = {
  "branch",
  color = { bg = colors.green, fg = colors.white },
  separator = { left = "", right = "" },
}

local diff = {
  "diff",
  diff_color = {
    added = { fg = colors.jelly_green },
    modified = { fg = colors.jelly_yellow },
    removed = { fg = colors.jelly_red },
  },
  color = { bg = colors.white, fg = colors.white },
  separator = { left = "", right = "" },
}

local modes = {
  "mode",
  fmt = function(str) return str:sub(1, 1) end,
  -- color = { bg = function(str) end, fg = colors.black },
  separator = {
    left = "",
    -- right = ""
  },
}

local location = {
  "location",
  color = { bg = colors.blacker, fg = colors.white },
  separator = { left = "", right = "" },
}

local function getLspName()
  local msg = "No Lsp"
  local next = next
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then return msg end
  local lsp_clients = {}
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    -- if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then return " " .. client.name end
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then table.insert(lsp_clients, client.name) end
  end
  if next(lsp_clients) == nil then return msg end
  return " " .. table_concat(lsp_clients, " ")
end

local function getLspColor()
  local next = next
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then return colors.grey end
  return colors.green
end

local dia = {
  "diagnostics",
  color = { bg = colors.dark, fg = colors.white },
  separator = { left = "", right = "" },
}

local lsp = {
  function() return getLspName() end,
  separator = { left = "", right = "" },
  color = { bg = getLspColor(), fg = colors.black },
}

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = theme,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      -- tabline = 1000,
      winbar = 1000,
    },
  },

  sections = {
    lualine_a = {
      modes,
      filename,
      filetype,
    },
    lualine_b = {},
    lualine_c = {},

    lualine_x = {
      space,
      {
        color = { fg = colors.yellow },
      },
    },

    lualine_y = {
      -- fileformat,
      -- encoding,
    },
    lualine_z = {
      location,
      dia,
      lsp,
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
}
