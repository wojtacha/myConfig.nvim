local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
}
local objects = { "nvim-treesitter/nvim-treesitter-textobjects" }

local playground = { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" }

local helm = {
  "qvalentin/helm-ls.nvim",
  ft = "helm",
  opts = {
    conceal_templates = {
      -- enable the replacement of templates with virtual text of their current values
      enabled = false, -- this might change to false in the future
    },
    indent_hints = {
      -- enable hints for indent and nindent functions
      enabled = true,
      -- show the hints only for the line the cursor is on
      only_for_current_line = true,
    },
  },
}

return { treesitter, playground, helm, objects }
