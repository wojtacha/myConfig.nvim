local Curl = require("plenary.curl")
local config = require("codecompanion.config")
local log = require("codecompanion.utils.log")
local openai = require("codecompanion.adapters.http.openai")
local utils = require("codecompanion.utils.adapters")

local _cache_expires
local _cache_file = vim.fn.tempname()
local _cached_models = {}

local function _models(opts)
  if opts and opts.last then return _cached_models and _cached_models[1] end
  return _cached_models or {}
end

-- Try to list models; if the endpoint isn't implemented, fall back to env/default model
local function get_models(self, opts)
  if _cached_models and _cache_expires and _cache_expires > os.time() then return _models(opts) end

  _cached_models = {}

  local adapter = require("codecompanion.adapters").resolve(self)
  if not adapter then
    log:error("Portkey adapter resolution failed in get_models()")
    return {}
  end

  utils.get_env_vars(adapter)

  local url = adapter.env_replaced.url
  local models_endpoint = adapter.env_replaced.models_endpoint

  -- Build Portkey headers
  local headers = { ["content-type"] = "application/json" }
  if adapter.env_replaced.api_key and adapter.env_replaced.api_key ~= "" then headers["x-portkey-api-key"] = adapter.env_replaced.api_key end
  print(headers)
  print(url)
  print(models_endpoint)

  local ok, response = pcall(
    function()
      return Curl.get(url .. models_endpoint, {
        sync = true,
        headers = headers,
        insecure = config.adapters.http.opts.allow_insecure,
        proxy = config.adapters.http.opts.proxy,
      })
    end
  )

  if ok and response and response.status == 200 then
    local okj, json = pcall(vim.json.decode, response.body)
    if okj and json and json.data then
      for _, m in ipairs(json.data) do
        -- OpenAI-compatible /v1/models payloads usually have { id = "..." }
        table.insert(_cached_models, m.id or m.name or m.model)
      end
    end
  end

  -- Fallback if /v1/models isn't available
  if #_cached_models == 0 then
    local env_model = adapter.env_replaced.model
    if env_model and env_model ~= "" then
      _cached_models = { env_model }
    else
      _cached_models = { "@claude-codegen-poc/claude-sonnet-4-5-20250929" }
    end
  end

  _cache_expires = utils.refresh_cache(_cache_file, config.adapters.http.opts.cache_models_for)
  return _models(opts)
end

---@class CodeCompanion.HTTPAdapter.Portkey: CodeCompanion.HTTPAdapter
return {
  name = "portkey",
  formatted_name = "Portkey (OpenAI compatible)",
  roles = { llm = "assistant", user = "user" },
  opts = {
    stream = true,
    tools = true,
    vision = false,
  },
  features = { text = true, tokens = true },

  url = "${url}${chat_url}",

  env = {
    api_key = "PORTKEY_API_KEY", -- required
    url = "PORTKEY_URL",
    chat_url = "/v1/chat/completions",
    models_endpoint = "/v1/models", -- will be tried; if 404, we fall back
    model = "@claude-codegen-poc/claude-sonnet-4-5-20250929", -- optional: set a default model here
  },

  -- IMPORTANT: No Authorization header; Portkey uses x-portkey-* headers
  headers = {
    ["Content-Type"] = "application/json",
    ["x-portkey-api-key"] = "${api_key}",
  },

  handlers = {
    setup = function(self)
      if self.opts and self.opts.stream then
        self.parameters.stream = true
        self.parameters.stream_options = { include_usage = true }
      end
      self.parameters.max_tokens = tonumber(self.parameters.max_tokens) or tonumber(vim.env.PORTKEY_MAX_TOKENS) or 1024
      return true
    end,

    -- Reuse all OpenAI format/stream handlers
    tokens = function(self, data) return openai.handlers.tokens(self, data) end,
    form_parameters = function(self, params, messages) return openai.handlers.form_parameters(self, params, messages) end,
    form_messages = function(self, messages) return openai.handlers.form_messages(self, messages) end,
    form_tools = function(self, tools) return openai.handlers.form_tools(self, tools) end,
    chat_output = function(self, data, tools) return openai.handlers.chat_output(self, data, tools) end,
    inline_output = function(self, data, context) return openai.handlers.inline_output(self, data, context) end,
    tools = {
      format_tool_calls = function(self, tools) return openai.handlers.tools.format_tool_calls(self, tools) end,
      output_response = function(self, tool_call, output) return openai.handlers.tools.output_response(self, tool_call, output) end,
    },
    on_exit = function(self, data) return openai.handlers.on_exit(self, data) end,
  },

  schema = {
    ---@type CodeCompanion.Schema
    model = {
      order = 1,
      mapping = "parameters",
      type = "enum",
      desc = "Portkey model id to use",
      default = function(self) return get_models(self, { last = true }) end,
      choices = function(self) return get_models(self) end,
    },
    ---@type CodeCompanion.Schema
    max_tokens = {
      order = 2,
      mapping = "parameters",
      type = "number",
      optional = true,
      default = function(self)
        local model = self.schema.model.default
        if self.schema.model.choices[model] and self.schema.model.choices[model].opts and self.schema.model.choices[model].opts.can_reason then
          return self.schema.thinking_budget.default + 1000
        end
        return 4096
      end,
      desc = "The maximum number of tokens to generate before stopping. This parameter only specifies the absolute maximum number of tokens to generate. Different models have different maximum values for this parameter.",
      validate = function(n) return n > 0 and n <= 128000, "Must be between 0 and 128000" end,
    },
  },
}
