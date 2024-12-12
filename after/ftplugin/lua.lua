local set = vim.opt_local

set.shiftwidth = 2
set.expandtab = true

-- this needs to be here in after folder because opt can be overridden by default lua configuration
set.formatoptions:remove("r")
set.formatoptions:remove("o")
