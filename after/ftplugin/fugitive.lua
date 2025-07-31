local wk = require("which-key")

wk.add({
  { "cc", desc = "Commit" },
  { "ca", desc = "Commit ammend" },
  { "ce", desc = "Commit ammend (Old message)" },
  { "czz", desc = "Stash tracked" },
  { "czw", desc = "Stash tracked keep stage" },
  { "czs", desc = "Stash staged" },
  { "cza", desc = "Stash apply --index" },
  { "czA", desc = "Stash apply" },
})
