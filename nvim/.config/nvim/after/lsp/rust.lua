return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
    },
  },
}
