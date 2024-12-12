vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.mdx" },
  callback = function() vim.o.filetype = "dart" end,
})
