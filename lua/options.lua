--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: For more options, you can see `:help option-list`

local opt = vim.opt
-- Make line numbers default
opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() opt.clipboard = "unnamedplus" end)

-- opt.shada = { "'10", "<0", "s10", "h" }

-- [[ Setting options ]]
-- See `:help vim.o`

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true
opt.swapfile = false

-- Best search settings :)
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
opt.timeoutlen = 300
-- Decrease update time
opt.timeout = true

-- Configure how new splits should be opened
opt.splitright = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.listchars = { eol = "↵", trail = "·", tab = "·┈", nbsp = "␣", multispace = "￮", extends = "▶", precedes = "◀" }

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Show which line your cursor is on
opt.cursorline = true
opt.cursorlineopt = "screenline,number"

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
opt.confirm = true

-- Set leader key
-- This needs to be set before lazy.nvim
vim.g.mapleader = " "

opt.signcolumn = "yes"
opt.relativenumber = true

opt.more = false
opt.wrap = true
opt.linebreak = true

-- `o` command does not add a comment
opt.foldmethod = "manual"
opt.shiftwidth = 2

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

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"
-- NOTE: You should make sure your terminal supports this
