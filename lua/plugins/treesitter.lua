local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
  version = "v0.10.0",
}
local objects = { "nvim-treesitter/nvim-treesitter-textobjects" }

local context = {
  "nvim-treesitter/nvim-treesitter-context",
  lazy = false,
  version = "v1.0.0",
  keys = {
    { "[c", function() require("treesitter-context").go_to_context(vim.v.count1) end, desc = "go to context", silent = true, mode = "n" },
  },
}

return { treesitter, context, objects }
