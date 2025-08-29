--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: For more options, you can see `:help option-list`

local o = vim.opt
-- Make line numbers default
o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
o.mouse = "a"

-- Don't show the mode, since it's already in the status line
o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() o.clipboard = "unnamedplus" end)

-- opt.shada = { "'10", "<0", "s10", "h" }

-- [[ Setting options ]]
-- See `:help vim.o`

-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true
o.swapfile = false

-- Best search settings :)
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

-- Keep signcolumn on by default
o.signcolumn = "yes"

-- Decrease update time
o.updatetime = 250

-- Decrease mapped sequence wait time
o.timeoutlen = 300
-- Decrease update time
o.timeout = true

-- window border for floating windows
o.winborder = "rounded"

-- Configure how new splits should be opened
o.splitright = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.listchars = { eol = "↵", trail = "·", tab = "·┈", nbsp = "␣", multispace = "￮", extends = "▶", precedes = "◀" }

-- Preview substitutions live, as you type!
o.inccommand = "split"

-- Show which line your cursor is on
o.cursorline = true
o.cursorlineopt = "screenline,number"

-- Minimal number of screen lines to keep above and below the cursor.
o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
o.confirm = true

-- Set leader key
-- This needs to be set before lazy.nvim
vim.g.mapleader = " "

o.signcolumn = "yes"
o.relativenumber = true

o.more = false
o.wrap = true
o.linebreak = true

-- `o` command does not add a comment
o.foldmethod = "manual"
o.shiftwidth = 2

-- Set highlight on search
o.hlsearch = true

-- Set completeopt to have a better completion experience
o.completeopt = "menuone,noselect"
-- NOTE: You should make sure your terminal supports this
