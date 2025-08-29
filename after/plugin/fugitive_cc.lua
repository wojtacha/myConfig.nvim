local grp = vim.api.nvim_create_augroup("FugitiveCCOverride", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = grp,
  pattern = { "fugitive", "git", "fugitiveblame" },
  callback = function(args)
    pcall(vim.api.nvim_buf_del_keymap, args.buf, "n", "cc")

    vim.keymap.set("n", "cc", "<cmd>Git -p commit<CR>", {
      buffer = args.buf,
      silent = true,
      nowait = true,
    })
  end,
})
