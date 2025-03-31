local lsp = require("lsp-zero")
local lsp_zero_preset = lsp.preset({})

lsp.on_attach(function(_, bufnr) lsp.default_keymaps({ buffer = bufnr }) end)

-- (Optional) Configure lua language server for neovim
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" },
})

local lspconfig = require("lspconfig")
local vim_capabilities = vim.lsp.protocol.make_client_capabilities()
vim_capabilities.textDocument.completion.completionItem.snippetSupport = true

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

lsp.skip_server_setup({ "jdtls", "ruby_ls" })

lspconfig.terraformls.setup({})

lspconfig.lua_ls.setup(lsp_zero_preset.nvim_lua_ls())

lspconfig.sourcekit.setup({
  cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
  single_file_support = true,
})

lspconfig.ts_ls.setup({
  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
})

-- GO ---
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  require("inlay-hints").on_attach(client, bufnr)

  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = {
      border = "rounded",
    },
  }, bufnr)
end

lspconfig.gopls.setup({
  cmd = { "gopls" },
  -- for postfix snippets and analyzers
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  single_file_support = true,
  capabilities = vim_capabilities,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
        shadow = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,

        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      gofumpt = true,
      staticcheck = true,
    },
  },
  on_attach = on_attach,
})

-- PYTHON --
-- deprecated use ruff!! --
-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
lspconfig.ruff.setup({
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
})

lspconfig.pylsp.setup({
  capabilities = vim_capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          -- this ignores the E501 line length error, I use ruff for that
          ignore = { "E501" },
        },
        -- black = {enabled = false},
      },
    },
  },
})

lspconfig.jedi_language_server.setup({
  capabilities = cmp_capabilities,
  init_options = {
    codeAction = {
      nameExtractVariable = "jls_extract_var",
      nameExtractFunction = "jls_extract_def",
    },
    completion = {
      disableSnippets = false,
      resolveEagerly = false,
      ignorePatterns = {},
    },
    diagnostics = {
      enable = true,
      didOpen = true,
      didChange = true,
      didSave = true,
    },
    hover = {
      enable = true,
      disable = {
        class = { all = false, names = {}, fullNames = {} },
        ["function"] = { all = false, names = {}, fullNames = {} },
        instance = { all = false, names = {}, fullNames = {} },
        keyword = { all = false, names = {}, fullNames = {} },
        module = { all = false, names = {}, fullNames = {} },
        param = { all = false, names = {}, fullNames = {} },
        path = { all = false, names = {}, fullNames = {} },
        property = { all = false, names = {}, fullNames = {} },
        statement = { all = false, names = {}, fullNames = {} },
      },
    },
    jediSettings = {
      autoImportModules = {},
      caseInsensitiveCompletion = true,
      debug = false,
    },
    markupKindPreferred = "markdown",
    workspace = {
      extraPaths = {},
      symbols = {
        ignoreFolders = { ".nox", ".tox", ".venv", "__pycache__", "venv" },
        maxSymbols = 20,
      },
    },
  },
})

lspconfig.html.setup({
  capabilities = vim_capabilities,
})

lspconfig.yamlls.setup({
  on_attach = require("kubeschema").on_attach,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ---@diagnostic disable-next-line
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*play*.{yml,yaml}",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
      },
      format = {
        enable = true,
      },
      hover = true,
      completion = true,

      customTags = {
        "!fn",
        "!And",
        "!If",
        "!Not",
        "!Equals",
        "!Or",
        "!FindInMap sequence",
        "!Base64",
        "!Cidr",
        "!Ref",
        "!Ref Scalar",
        "!Sub",
        "!GetAtt",
        "!GetAZs",
        "!ImportValue",
        "!Select",
        "!Split",
        "!Join sequence",
      },
    },
  },
})

lsp.setup()
