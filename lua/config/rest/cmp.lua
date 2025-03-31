require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require "cmp"

local icons = {
  Method = " ",
  Function = "󰡱 ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = " ",
  Property = " ",
  Interface = " ",
  Enum = " ",
  EnumMember = " ",
  Reference = " ",
  Struct = " ",
  Event = " ",
  Constant = "󰏿 ",
  Keyword = " ",

  Module = "󰏗 ",
  Package = "󰏗 ",
  Namespace = "󰅩 ",

  Unit = " ",
  Value = "󰎠 ",
  String = " ",
  Number = "󰎠 ",
  Boolean = " ",
  Array = " ",
  Object = " ",
  Key = "󱕵 ",
  Null = " ",

  Text = " ",
  Snippet = " ",
  Color = "󰏘 ",
  File = "󰈮 ",
  Folder = "󰉋 ",
  Operator = " ",
  TypeParameter = " ",
  Copilot = " ",
  Cody = " ",
  ellipse = "…",
}

local format = {
  fields = { "kind", "abbr", "menu" },
  format = function(_, vim_item)
    local kind = vim_item.kind
    local icon = (icons[kind] or ""):gsub("%s+", "")
    vim_item.kind = " " .. icon
    vim_item.menu = kind
    local text = vim_item.abbr
    local max = math.floor(math.max(vim.o.columns / 4, 50))
    if vim.fn.strcharlen(text) > max then vim_item.abbr = vim.fn.strcharpart(text, -1, max - 1) .. icons.ellipse end
    return vim_item
  end,
}

cmp.setup {
  preselect = cmp.PreselectMode.None,
  mapping = {
    ["<C-n>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<C-p>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ["<c-y>"] = function(fallback)
      if cmp.visible() then
        cmp.confirm { select = true }
      else
        fallback() -- If you use vim-endwise, this fallback will behave the same as vim-endwise.
      end
    end,
  },
  sorting = {
    priority_weight = 1,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- copied from cmp-under, but I don't think I need the plugin for this.
      -- I might add some more of my own.
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },

  sources = cmp.config.sources {
    { name = "luasnip" },
    -- TODO: include cody or other copilot later on
    -- { name = "cody" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "buffer",                 max_item_count = 4 },
    { name = "path" },
  },
  experimental = {
    ghost_text = true,
  },

  -- formatting = cmp_format,
  formatting = format,
}
