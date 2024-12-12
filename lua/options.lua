-- Set leader key
-- This needs to be set before lazy.nvim
vim.g.mapleader = " "

local opt = vim.opt

opt.signcolumn = "yes"
opt.number = true
opt.relativenumber = true

opt.listchars = 'eol:↵,trail:￮,tab:·┈,nbsp:␣,multispace:￮,extends:▶,precedes:◀'
-- Save undo history
opt.undofile = true
opt.swapfile = false
-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

opt.more = false
opt.wrap = true
opt.linebreak = true

-- `o` command does not add a comment
opt.inccommand = "split"
opt.foldmethod = "manual"
opt.shiftwidth = 2
opt.splitright = true

-- opt.shada = { "'10", "<0", "s10", "h" }
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
opt.clipboard = "unnamedplus"
-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
opt.hlsearch = true

-- this is autocommand for toggling cursorline on active window
vim.cmd([[
:augroup CursorLine
:    au!
:    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
:    au WinLeave * setlocal nocursorline
:augroup END
]])

opt.cursorline = true
opt.cursorlineopt = "screenline,number"

opt.mouse = "a"
-- cursorline
-- cursorcolumn
-- Enable break indent
opt.breakindent = true

-- Decrease update time
opt.timeout = true
opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"
-- NOTE: You should make sure your terminal supports this
