local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = function() require("nvim-treesitter.install").update { with_sync = true } end,
}
local objects = { "nvim-treesitter/nvim-treesitter-textobjects" }

local playground = { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" }

local helm = { "towolf/vim-helm" }

return { treesitter, playground, helm, objects }
