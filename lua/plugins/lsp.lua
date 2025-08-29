return {
  { "williamboman/mason.nvim", opts = {}, cmd = { "Mason" } },
  { "williamboman/mason-lspconfig.nvim", config = function()
    require("mason-lspconfig").setup({
      automatic_enable = true,
    })
  end },
  { "j-hui/fidget.nvim", opts = {} },
  -- {
  --   "simrat39/inlay-hints.nvim",
  --   config = function()
  --     require("inlay-hints").setup({
  --       eol = {
  --         right_align = true,
  --       },
  --     })
  --   end,
  -- },
}
