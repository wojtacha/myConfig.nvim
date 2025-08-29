local wk = require("which-key")
-- DEFAULTS --
-- i dont use s
vim.keymap.set({ "n", "x" }, "s", "<Nop>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block of code up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block of code down" })

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Jump down half page and center" })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Jump up half page and center" })
vim.keymap.set({ "n" }, "*", "*zz", { desc = "Jump to next search occurence and center" })
vim.keymap.set({ "n" }, "#", "#zz", { desc = "Jump to previous search occurence and center" })

vim.keymap.set({ "n" }, "<Esc><Esc>", "<Esc>:nohlsearch<CR><Esc>", { desc = "Unhighlight search occurences", silent = true, noremap = true })
vim.keymap.set("n", "n", "nzz", { desc = "Next search occurence and focus view" })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search occurence and focus view" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("v", "<leader>fa", function()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local mode = vim.fn.mode()
  local region = vim.fn.getregion(start_pos, end_pos, { type = mode })[1]
  print(vim.inspect(region))
end, { noremap = true, silent = true, desc = "Show visual selection" })

-- its time to say godbye
-- vim.keymap.set("i", "kj", "<Esc>", { desc = "yet another esc", noremap = true })

vim.keymap.set({ "n", "x" }, "x", [["_x]], { desc = "x command send char to black hole register", noremap = true })
vim.keymap.set("x", "p", [["_dP]], { desc = "another paste command send char to black hole register", noremap = true })

-- Check if a Trouble window is open
local function has_trouble_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ft == "trouble" then return true end
  end
  return false
end

-- Wrap navigation logic
local function next_item()
  if has_trouble_window() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    vim.cmd("silent! cnext")
  end
end

local function prev_item()
  if has_trouble_window() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    vim.cmd("silent! cprev")
  end
end

-- Keymaps
vim.keymap.set("n", "<C-j>", next_item, { desc = "Next Trouble/QF item", silent = true })
vim.keymap.set("n", "<C-k>", prev_item, { desc = "Prev Trouble/QF item", silent = true })

-- DEFAULTS END --

vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Toggle Explorer" })

vim.keymap.set("n", "<F1>", function() require("nvim-tree.api").tree.toggle({ focus = true, find_file = true }) end, { silent = true, noremap = true })

vim.keymap.set("n", "<F4>", "<cmd>set  list! list?<cr>", { silent = true, noremap = true }) -- show whitespaces
