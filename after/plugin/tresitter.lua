require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "go",
    "vim",
    "vimdoc",
    "helm",
    "json",
    "yaml",
    "bash",
    "regex",
    "gitignore",
  },
  modules = {},
  incremental_selection = { enable = true },
  textobjects = {
    enable = true,
    select = {
      enable = true,
      keymaps = {

        -- Built-in captures.
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
  },
  sync_install = false,
  auto_install = true,
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  ignore_install = {},

  highlight = {
    enable = true,
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop., vim.api.nvim_buf_get_name(buf))
    --     cker exec -it 817da01eb28616f3688e63c9dd5ce785ea2033137cd2e5edca5bb3fcb5972718 /bin/sh
    --
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,
  },
  -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  -- Using this option may slow down your editor, and you may see some duplicate highlights.
  -- Instead of true it can also be a list of languages
  additional_vim_regex_highlighting = false,
})

vim.treesitter.language.register("yaml", "yaml.helm-values")
