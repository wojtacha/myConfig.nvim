-- Install with: npm i -g add yaml-language-server
-- currently using mason

---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  settings = {
    yaml = {
      -- Using the schemastore plugin for schemas.
      schemastore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
  on_init = function(client)
    --- https://github.com/neovim/nvim-lspconfig/pull/4016
    --- Since formatting is disabled by default if you check `client:supports_method('textDocument/formatting')`
    --- during `LspAttach` it will return `false`. This hack sets the capability to `true` to facilitate
    --- autocmd's which check this capability
    client.server_capabilities.documentFormattingProvider = true
  end,
}
