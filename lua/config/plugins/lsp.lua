return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },

      -- Provides on attach function to yamlls server
      { "imroc/kubeschema.nvim", opts = {} },
      { "ms-jpq/coq_nvim", branch = "coq" },
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
      -- Allows extra capabilities provided by nvim-cmp
      -- "hrsh7th/cmp-nvim-lsp",
    },

    init = function()
      vim.g.coq_settings = {
        auto_start = true, -- if you want to start COQ at startup
        -- Your COQ settings here
      }
    end,

    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })) end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},

        -- TODO: to nie dziala trzeba poza tym innym masonem wjebac
        -- gh_actions_ls = {
        --   cmd = { "gh-actions-language-server", "--stdio" },
        --   filetypes = { "yaml" },
        --   -- Only attach to yaml files that are GitHub workflows instead of all yaml
        --   -- files. (A nil root_dir and no single_file_support results in the LSP not
        --   -- attaching.) For details, see #3558
        --   root_dir = function(filename)
        --     local dirs_to_check = {
        --       ".github/workflows",
        --       ".forgejo/workflows",
        --       ".gitea/workflows",
        --     }
        --
        --     local dir = vim.fs.dirname(filename)
        --     for _, subdir in ipairs(dirs_to_check) do
        --       local match = vim.fs.find(subdir, { path = dir, upward = true })[1]
        --       if match and vim.fn.isdirectory(match) == 1 and vim.fs.dirname(filename) == match then return match end
        --     end
        --
        --     return nil
        --   end,
        --   -- Disabling "single file support" is a hack to avoid enabling this LS for
        --   -- every random yaml file, so `root_dir()` can control the enablement.
        --   single_file_support = false,
        --   capabilities = {
        --     workspace = {
        --       didChangeWorkspaceFolders = {
        --         dynamicRegistration = true,
        --       },
        --     },
        --   },
        -- },

        yamlls = {
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
        },

        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          single_file_support = true,
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
          -- on_attach = on_attach,
        },

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath("config") and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")) then return end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- Depending on the usage, you might want to add additional paths here.
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
              },
            })
          end,
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        ruff = {},
        pyright = {},
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            local coq = require("coq") -- add this
            require("lspconfig")[server_name].setup(coq.lsp_ensure_capabilities(server))
          end,
        },
      })
    end,
  },

  -- -- (Optional) Configure lua language server for neovim
  -- local lspconfig = require "lspconfig"
  -- local vim_capabilities = vim.lsp.protocol.make_client_capabilities()
  -- vim_capabilities.textDocument.completion.completionItem.snippetSupport = true
  --
  -- local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  --
  -- lspconfig.terraformls.setup {}
  --
  -- lspconfig.lua_ls.setup(lsp_zero_preset.nvim_lua_ls())
  --
  -- lspconfig.sourcekit.setup {
  --   cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
  --   single_file_support = true,
  -- }
  --
  -- lspconfig.ts_ls.setup {
  --   settings = {
  --     completions = {
  --       completeFunctionCalls = true,
  --     },
  --   },
  -- }
  --
  -- -- GO ---
  -- local on_attach = function(client, bufnr)
  --   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  --   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  --   require("inlay-hints").on_attach(client, bufnr)
  -- end
  --
  --
  -- -- PYTHON --
  -- -- deprecated use ruff!! --
  -- -- Configure `ruff-lsp`.
  -- -- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
  -- -- For the default config, along with instructions on how to customize the settings
  -- lspconfig.ruff.setup {
  --   init_options = {
  --     settings = {
  --       -- Any extra CLI arguments for `ruff` go here.
  --       args = {},
  --     },
  --   },
  -- }
  --
  -- lspconfig.pylsp.setup {
  --   capabilities = vim_capabilities,
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         pycodestyle = {
  --           -- this ignores the E501 line length error, I use ruff for that
  --           ignore = { "E501" },
  --         },
  --         -- black = {enabled = false},
  --       },
  --     },
  --   },
  -- }
  --
  -- lspconfig.jedi_language_server.setup {
  --   capabilities = cmp_capabilities,
  --   init_options = {
  --     codeAction = {
  --       nameExtractVariable = "jls_extract_var",
  --       nameExtractFunction = "jls_extract_def",
  --     },
  --     completion = {
  --       disableSnippets = false,
  --       resolveEagerly = false,
  --       ignorePatterns = {},
  --     },
  --     diagnostics = {
  --       enable = true,
  --       didOpen = true,
  --       didChange = true,
  --       didSave = true,
  --     },
  --     hover = {
  --       enable = true,
  --       disable = {
  --         class = { all = false, names = {}, fullNames = {} },
  --         ["function"] = { all = false, names = {}, fullNames = {} },
  --         instance = { all = false, names = {}, fullNames = {} },
  --         keyword = { all = false, names = {}, fullNames = {} },
  --         module = { all = false, names = {}, fullNames = {} },
  --         param = { all = false, names = {}, fullNames = {} },
  --         path = { all = false, names = {}, fullNames = {} },
  --         property = { all = false, names = {}, fullNames = {} },
  --         statement = { all = false, names = {}, fullNames = {} },
  --       },
  --     },
  --     jediSettings = {
  --       autoImportModules = {},
  --       caseInsensitiveCompletion = true,
  --       debug = false,
  --     },
  --     markupKindPreferred = "markdown",
  --     workspace = {
  --       extraPaths = {},
  --       symbols = {
  --         ignoreFolders = { ".nox", ".tox", ".venv", "__pycache__", "venv" },
  --         maxSymbols = 20,
  --       },
  --     },
  --   },
  -- }
  --
  -- lspconfig.html.setup {
  --   capabilities = vim_capabilities,
  -- }
  --
  -- TODO:  check if cmp needs to be there  and remove lsp zero

  --
  --     {  -- Optional
  --       "williamboman/mason.nvim",
  --       config = function()
  --         require("mason").setup {
  --           ui = {
  --             border = "double",
  --             icons = {
  --               package_installed = "✓",
  --               package_pending = "➜",
  --               package_uninstalled = "✗",
  --             },
  --           },
  --         }
  --       end,
  --     },
  --     { "hrsh7th/nvim-cmp" },
  --     -- Required
  --     { "hrsh7th/cmp-nvim-lsp" },         -- Required
  --     { "hrsh7th/cmp-buffer" },           -- Optional
  --     { "hrsh7th/cmp-path" },             -- Optional
  --     { "saadparwaiz1/cmp_luasnip" },     -- Optional
  --     { "hrsh7th/cmp-nvim-lua" },         -- Optional
  --     -- Snippets
  --     { "L3MON4D3/LuaSnip" },             -- Required
  --     { "rafamadriz/friendly-snippets" }, -- Optional
  --   },
  -- },

  {
    "imroc/kubeschema.nvim",
    opts = {},
  },

  {
    "ray-x/lsp_signature.nvim", -- Show function signature when you type
    event = "VeryLazy",
  },
  {
    "simrat39/inlay-hints.nvim",
    config = function()
      require("inlay-hints").setup({
        eol = {
          right_align = true,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local linter = require("lint")

      local default_linter_set = {
        yaml = { "actionlint", "ansible_lint" },
        lua = { "selene" },
        ruby = { "rubocop" },
        python = { "ruff" },
      }

      local linter_set = {}

      for ft, linters in pairs(default_linter_set) do
        linter_set[ft] = {} -- Initialize a table for each filetype
        for _, lntr in ipairs(linters) do
          if vim.fn.executable(lntr) == 1 then table.insert(linter_set[ft], lntr) end
        end
      end

      -- Assign the linters_by_ft
      linter.linters_by_ft = linter_set

      local lint = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint,
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {},
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format", "ruff_fix" }
          else
            return { "isort", "black" }
          end
        end,
        go = { "golangci-lint", "gofmt" },
        lua = { "stylua" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        terraform = { "tofu_fmt" },
        yaml = { "yamlfmt" },
        json = { "fixjson" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,

      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
