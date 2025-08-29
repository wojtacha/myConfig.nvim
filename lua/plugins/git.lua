return {
  -- { -- Adds git related signs to the gutter, as well as utilities for managing changes
  --   "lewis6991/gitsigns.nvim",
  --   lazy = false,
  --   opts = {
  --     signs = {
  --       add = { text = "+" },
  --       change = { text = "~" },
  --       delete = { text = "_" },
  --       topdelete = { text = "‾" },
  --       changedelete = { text = "~" },
  --     },
  --
  --     signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  --     numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  --     linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  --     word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  --   },
  --   keys = {
  --
  --     { "<leader>gb", function() vim.cmd("Gitsigns blame") end, desc = "Git [b]lame toggle", noremap = true, mode = "n" },
  --     { "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", desc = "Git show [h]unk", noremap = true, mode = "n" },
  --
  --     -- { "<leader>gh", "<cmd>Gitsigns toggle_linehl<CR>", desc = "Toggle Git line highlight", mode = "n" },
  --     -- { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "Git diff this", mode = "n" },
  --     -- { "<leader>gD", "<cmd>Gitsigns toggle_deleted<CR>", desc = "Toggle Git deleted lines", mode = "n" },
  --   },
  -- },
  {
    "tpope/vim-fugitive",
    lazy = false,
    cmd = "Git",
    keys = { { "<leader>gg", ":Git<CR>", desc = "Fugitive Git", mode = "n" }, { "<leader>gb", ":Git blame<CR>", desc = "Git blame", mode = "n" } },
  },
}
