return {
  "mistweaverco/kulala.nvim",
  keys = {
    { "<leader>rs", require("kulala").run, desc = "Send request" },
    { "<leader>ra", require("kulala").run_all, desc = "Send all requests" },
    { "<leader>rp", require("kulala").replay, desc = "Replay last request" },
    { "<leader>ri", require("kulala").inspect, desc = "Inspect request" },
    { "<leader>ro", require("kulala").open, desc = "Open default UI" },
    { "<leader>rt", require("kulala").show_stats, desc = "Show request stats" },
    { "<leader>rb", require("kulala").scratchpad, desc = "Open scratchpad" },
    { "<leader>rc", require("kulala").copy, desc = "Copy as cURL" },
    { "<leader>rC", require("kulala").from_curl, desc = "Iimport from cURL" },
  },
  ft = { "http", "rest" },
}
