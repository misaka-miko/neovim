vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- local conform_group = vim.api.nvim_create_augroup("ConformLazy", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = conform_group,
--   once = true,
--   callback = function()
--     conform.format({ bufnr = vim.api.nvim_get_current_buf() })
--   end,
--   desc = "Lazy load conform on save",
-- })
