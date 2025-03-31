local set = vim.opt_local

set.expandtab = false
set.tabstop = 4
set.shiftwidth = 4

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params(0, "utf-8")
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})

-- local function goimports(timeoutms)
--   local context = { source = { organizeImports = true } }
--   vim.validate { context = { context, "t", true } }
--
--   local params = vim.lsp.util.make_range_params()
--   params.context = context
--
--   -- See the implementation of the textDocument/codeAction callback
--   -- (lua/vim/lsp/handler.lua) for how to do this properly.
--   local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeoutms)
--   if not result or next(result) == nil then return end
--   -- local actions = result[1].result
--   -- if not actions then return end
--   -- local action = actions[1]
--   local actions = {}
--   local action = {}
--
--   for _, res in pairs(result) do
--     if res.result then
--       for _, a in ipairs(res.result) do
--         if a.kind == "source.organizeImports" then
--           action = a
--         end
--         table.insert(actions, action)
--       end
--     end
--   end
--   if vim.tbl_isempty(actions) then return end
--
--
--   -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
--   -- is a CodeAction, it can have either an edit, a command or both. Edits
--   -- should be executed first.
--   if action.edit or type(action.command) == "table" then
--     if action.edit then
--       vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
--     end
--     if type(action.command) == "table" then
--       vim.lsp.buf.execute_command(action.command)
--     end
--   else
--     vim.lsp.buf.execute_command(action)
--   end
-- end
--
--
-- -- Go automatic imports on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.go" },
--   callback = function() goimports(1000) end,
-- })
