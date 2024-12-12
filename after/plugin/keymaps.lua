local wk = require "which-key"
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

vim.keymap.set(
  { "n" },
  "<Esc><Esc>",
  "<Esc>:nohlsearch<CR><Esc>",
  { desc = "Unhighlight search occurences", silent = true, noremap = true }
)
vim.keymap.set("n", "n", "nzz", { desc = "Next search occurence and focus view" })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search occurence and focus view" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("i", "kj", "<Esc>", { desc = "yet another esc", noremap = true })
vim.keymap.set({ "n", "x" }, "x", [["_x]], { desc = "x command send char to black hole register", noremap = true })
vim.keymap.set("x", "p", [["_dP]], { desc = "another paste command send char to black hole register", noremap = true })
-- quickfix window mappings
vim.keymap.set("n", "<C-j>", "<cmd>cn<cr>", { desc = "qf next" })
vim.keymap.set("n", "<C-k>", "<cmd>cp<cr>", { desc = "qf prev" })

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.add {
  { "<leader>d",  group = "[d]iagnostic" },
  { "<leader>dh", desc = "[d]iagnostic [h]ide" },
  { "<leader>di", desc = "[d]iagnostic [i]nfo" },
  { "<leader>dl", desc = "[d]iagnostic [l]ist" },
  { "<leader>dn", desc = "[d]iagnostic [n]ext" },
  { "<leader>dp", desc = "[d]iagnostic [p]rev" },
}
vim.keymap.set(
  "n",
  "<leader>di",
  "<cmd>lua vim.diagnostic.open_float()<CR>",
  { desc = "[d]iagnostic [i]nformation", noremap = true, silent = true }
)
-- vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "[d]iagnostic [l]ist" })
vim.keymap.set("n", "<leader>dh", vim.diagnostic.hide, { desc = "[d]iagnostic [h]ide" })
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "[d]iagnostic [n]ext" })
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "[d]iagnostic [p]rev" })

-- DEFAULTS END --
--

wk.add {
  { "<leader>f",  group = "find" },
  { "<leader>fb", desc = "[F]ind open [b]uffers" },
  { "<leader>ff", desc = "[F]ind [f]iles" },
  { "<leader>fh", desc = "[F]ind [h]elp" },
  { "<leader>fs", desc = "[F]ile [s]earch - inside live grep" },
}
local telescope = require "telescope.builtin"

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope frecency workspace=CWD<cr>", { desc = "[F]ind [f]iles" })

-- vim.keymap.set( "n", "<Leader>ff",
--   function()
--     require("telescope").extensions.frecency.frecency {
--       workspace = "CWD",
--       path_display = { "shorten" },
--       theme = "ivy",
--     }
--   end,
--   { desc = "[F]ind [f]iles" }
-- )
--
vim.keymap.set("n", "<leader>fw", telescope.grep_string, { desc = "[F]ind [w]ord" })
vim.keymap.set("n", "<leader>fs", telescope.live_grep, { desc = "[F]ile [s]earch - inside live grep" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "[F]ind open [b]uffers" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "[F]ind [h]elp" })
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope commands<cr>", { desc = "Toggle Commands Explorer" })

vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Toggle Explorer" })
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Toggle Explorer" })
vim.keymap.set("n", "<F2>", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<F3>", "<cmd>set  list! list?<cr>", { silent = true, noremap = true })

-- Harpoon
local harpoon = require "harpoon"
vim.keymap.set({ "n" }, "<C-n>", function() harpoon:list():add() end, { desc = "add harpoon mark", noremap = true })
vim.keymap.set(
  { "n" },
  "<C-e>",
  function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
  { desc = "Toggle harpoon menu", noremap = true }
)
vim.keymap.set({ "n" }, "<C-l>", function() harpoon:list():next() end, { desc = "next Harpoon mark", noremap = false })
vim.keymap.set({ "n" }, "<C-h>", function() harpoon:list():prev() end, { desc = "next Harpoon mark", noremap = false })

vim.keymap.set("n", "<leader>gg", vim.cmd.Git, { desc = "Toggle git window", noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>gb", "<cmd>Git branch<cr>", { desc = "Toggle git blame", noremap = true })

wk.add {
  { "<leader>g",  group = "[g]it" },
  { "<leader>gb", desc = "Git [b]ranch" },
  { "<leader>gg", desc = "Git [s]tages - tpope" },
  { "<leader>w",  desc = "[w]indow select" },
}

vim.keymap.set({ "n", "x" }, "ga", "<cmd>EasyAlign<cr>", { desc = "Easy Align from junegunn", noremap = false })
wk.add {
  { "ga", desc = "Easy Align" },
}

-- Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    wk.add {
      { "<leader>g",  group = "[g]it" },
      { "<leader>gb", desc = "Git [b]lame" },
      { "<leader>gg", desc = "Git lazy[g]it" },
      { "<leader>gs", desc = "Git [s]tages - tpope" },
      { "<leader>w",  desc = "[w]indow select" },
    }

    vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "declaration" })
    vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = ev.buf, desc = "definition" })
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { buffer = ev.buf, desc = "references" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "declaration" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "references" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover" })
    vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover" })
    vim.keymap.set("n", "<leader>li", function() print(vim.lsp.buf.implementation()) end,
      { buffer = ev.buf, desc = "implementation" })
    vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "signature_help" })
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "type_definition" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, buffer = ev.buf, desc = "rename" })
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "code_action" })
  end,
})
