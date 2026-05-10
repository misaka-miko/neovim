vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
})

require("mason").setup({
  ensure_installed = { "codelldb", "markdownlint-cli2", "markdown-toc", "pyright" },
})
