local M = {}

function M.laod()
  vim.pack.add({
    "https://github.com/iamcco/markdown-preview.nvim",
  })

  vim.fn["mkdp#util#install"]()

  vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", {
    desc = "Markdown Preview",
    silent = true,
  })

  vim.cmd([[do FileType]])
end

return M
