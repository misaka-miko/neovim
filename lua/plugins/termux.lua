-- if true then
--   return {}
-- end

return {
  -- Using termux installed lsp to handle platform error
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
        },
        lua_ls = {
          mason = false,
        },
        ruff = {
          mason = false,
        },
      },
    },
  },
}
