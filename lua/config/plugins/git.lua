return {
  {
    "lewis6991/gitsigns.nvim",
    config =
        function()
          require('gitsigns').setup {
            signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl      = true,  -- Toggle with `:Gitsigns toggle_numhl`
            linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff  = true,  -- Toggle with `:Gitsigns toggle_word_diff`
          }
        end
  },
  { "tpope/vim-fugitive", cmd = "Git" },
}
