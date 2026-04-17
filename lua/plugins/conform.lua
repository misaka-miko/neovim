local M = {}

M.loaded = false

local function load()
  if M.loaded then
    return
  end
  M.loaded = true

  vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
  })

  local conform = require("conform")
  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  })

  vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  end, { desc = "Format" })
end

vim.keymap.set("n", "<leader>cf", function()
  load()
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
end, { desc = "Format" })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("SetupConform", { clear = true }),
  once = true,
  callback = function()
    load()
    require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
  end,
  desc = "Lazy load conform on save",
})

return M
