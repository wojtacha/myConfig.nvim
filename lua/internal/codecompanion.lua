local M = {}

M.adapters = {
  anthropic = function()
    return require("codecompanion.adapters").extend("anthropic", {
      env = {
        api_key = "cmd:rg '^ANTHROPIC_API_KEY=' .env | cut -d '=' -f2",
      },
      schema = {
        extended_thinking = {
          default = true,
        },
      },
    })
  end,

  portkey = function()
    return require("codecompanion.adapters").extend("openai_compatible", {
      name = "old_portkey",
      formatted_name = "Old Portkey",
      url = "${portkey_url}", -- Changed: use the env variable
      env = {
        portkey_url = "cmd:rg '^PORTKEY_URL=' .env | cut -d '=' -f2",
        portkey_key = "cmd:rg '^PORTKEY_API_KEY=' .env | cut -d '=' -f2",
      },
      headers = {
        ["Content-Type"] = "application/json",
        ["x-portkey-api-key"] = "${portkey_key}",
        ["Authorization"] = "", -- Override the default Authorization header with empty string
      },
      parameters = {
        model = "${model}",
        max_tokens = "schema.max_tokens.default",
      },
      schema = {
        model = {
          order = 1,
          mapping = "parameters",
          type = "enum",
          default = "@claude-codegen-poc/claude-sonnet-4-5-20250929",
          choices = {
            "@daba-dev-bedrock-us-east-2/us.anthropic.claude-sonnet-4-20250929-v1:0",
            "@daba-dev-bedrock-us-east-2/us.anthropic.claude-3-5-haiku-20241022-v1:0",
            "@daba-dev-bedrock-us-east-2/us.anthropic.claude-opus-4-1-20250805-v1:0",
          },
          desc = "Portkey model identifier - select your preferred Claude model",
        },
        max_tokens = {
          order = 2,
          mapping = "parameters",
          type = "number",
          default = 2512,
          desc = "Maximum number of tokens to generate",
        },
      },
    })
  end,
}

return M
