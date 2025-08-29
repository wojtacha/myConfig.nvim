vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- This does not work
vim.api.nvim_create_user_command("Git", function(opts)
  if opts.fargs[1] == "push" then
    vim.cmd("Git -p push")
  else
    vim.cmd("Git " .. table.concat(opts.fargs, " "))
  end
end, {})

vim.api.nvim_create_user_command("Json", function()
  vim.cmd("%!jq")
  vim.cmd("set filetype=json")
end, {})
vim.api.nvim_create_user_command("Yaml", function() vim.cmd("set filetype=yaml") end, {})
