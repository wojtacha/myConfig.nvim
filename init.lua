local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("autocommands")
require("usercommands")
require("options")

---@type LazySpec
local plugins = "plugins"
require("lazy").setup(plugins, {
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
  ui = {
    wrap = true, -- wrap the lines in the ui
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = "rounded",
    title = "Lazy is crazy", ---@type string only works when border is not "none"
  },
})

-- vim.cmd.colorscheme("miss-dracula")
vim.cmd.colorscheme("rose-pine")

require("diagnostics")
