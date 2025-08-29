---@brief
---
--- https://github.com/golang/tools/tree/master/gopls
---
--- Google's lsp server for golang.

--- @class go_dir_custom_args
---
--- @field envvar_id string
---
--- @field custom_subdir string?

local mod_cache = nil
local std_lib = nil

---@param custom_args go_dir_custom_args
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(custom_args, on_complete)
  local cmd = { "go", "env", custom_args.envvar_id }
  vim.system(cmd, { text = true }, function(output)
    local res = vim.trim(output.stdout or "")
    if output.code == 0 and res ~= "" then
      if custom_args.custom_subdir and custom_args.custom_subdir ~= "" then res = res .. custom_args.custom_subdir end
      on_complete(res)
    else
      vim.schedule(
        function()
          vim.notify(
            ("[gopls] identify " .. custom_args.envvar_id .. " dir cmd failed with code %d: %s\n%s"):format(output.code, vim.inspect(cmd), output.stderr)
          )
        end
      )
      on_complete(nil)
    end
  end)
end

---@return string?
local function get_std_lib_dir()
  if std_lib and std_lib ~= "" then return std_lib end

  identify_go_dir({ envvar_id = "GOROOT", custom_subdir = "/src" }, function(dir)
    if dir then std_lib = dir end
  end)
  return std_lib
end

---@return string?
local function get_mod_cache_dir()
  if mod_cache and mod_cache ~= "" then return mod_cache end

  identify_go_dir({ envvar_id = "GOMODCACHE" }, function(dir)
    if dir then mod_cache = dir end
  end)
  return mod_cache
end

---@param fname string
---@return string?
local function get_root_dir(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients({ name = "gopls" })
    if #clients > 0 then return clients[#clients].config.root_dir end
  end
  if std_lib and fname:sub(1, #std_lib) == std_lib then
    local clients = vim.lsp.get_clients({ name = "gopls" })
    if #clients > 0 then return clients[#clients].config.root_dir end
  end
  return vim.fs.root(fname, "go.work") or vim.fs.root(fname, "go.mod") or vim.fs.root(fname, ".git")
end

---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    get_mod_cache_dir()
    get_std_lib_dir()
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    on_dir(get_root_dir(fname))
  end,
  single_file_support = true,

  settings = {
    gopls = {
      -- ANALYSES
      -- Static analyses help catch common mistakes and improve code quality.
      analyses = {
        unusedparams = true, -- Warn if a function parameter is never used in the function body.
        -- Helps catch unused args (common when refactoring).

        unusedwrite = true, -- Warn if a variable is assigned (written) but never actually read afterwards.
        -- Example:
        --   x = 42   // if `x` is never used later, this is flagged.
        -- Good for spotting unnecessary computations or dead code.

        nilness = true, -- Detect possible nil dereferences.
        -- Example: calling `foo.Bar()` when `foo` might be nil.
        -- This helps prevent runtime panics due to nil pointer access.

        shadow = true, -- Warn if a variable is redeclared in a narrower scope,
        -- "shadowing" an outer variable of the same name.
        -- Example:
        --   x := 10
        --   if cond {
        --       x := 20 // shadows outer x, can cause subtle bugs
        --   }

        unusedvariable = true, -- Warn if a declared local variable is never used.
        -- Example:
        --   y := 99 // if `y` is never read, this gets flagged.
        -- Helps keep the code clean and avoids clutter.
      },

      -- STATICCHECK
      -- Enables extra, production-grade checks from staticcheck.io.
      -- These go beyond gopls’ built-in analyses and cover best practices, bug-prone patterns,
      -- style improvements, and possible performance issues.
      staticcheck = true,

      matcher = "fuzzy", -- Controls how autocomplete matches text.
      -- Options: "fuzzy" (best for convenience), "casesensitive", "fastfuzzy".

      -- HINTS (inlay hints are inline annotations shown in your editor)
      hints = {
        assignvariabletypes = true, -- Show inferred types of variables on assignment.
        -- Example: `x := foo()` → x: *MyType

        compositeliteralfields = true, -- Show field names in composite literals when omitted.
        -- Example: `Point{1, 2}` → `.X: 1, .Y: 2`.

        compositeliteraltypes = true, -- Show type names for composite literals.
        -- Example: `{1, 2}` → `Point{1, 2}`.

        constantvalues = true, -- Show values of named constants.
        -- Example: `const Pi = 3.14` → usage shows `Pi(3.14)`.

        functiontypeparameters = true, -- Show type parameters in generic function signatures (Go 1.18+).
        -- Example: `func Map[T any](...)`.

        parameternames = true, -- Show parameter names at call sites.
        -- Example: `strings.Replace(s, old, new, n)` → `strings.Replace(s, old: "a", new: "b", n: -1)`.

        rangevariabletypes = true, -- Show inferred variable types in `for range`.
        -- Example: `for k, v := range m` → `k: string, v: int`.
      },

      -- FORMATTING
      -- Enforces gofumpt style (stricter version of gofmt with extra rules).
      -- Example: enforces spacing, imports order, and certain formatting for consistency.
      gofumpt = true,
    },
  },
}
