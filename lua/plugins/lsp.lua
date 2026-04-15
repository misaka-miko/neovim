return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      qmlls = {
        settings = {
          qmlls = {
            logLevel = "error",
          },
        },
      },
    },
  },
}
