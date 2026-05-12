vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "markdown",
    "rmd",
    "markdown.mdx",
    "norg",
    "org",
    "codecompanion",
  },
  group = vim.api.nvim_create_augroup("SetupMarkdown", { clear = true }),
  once = true,
  callback = function()
    require("plugins.markdown.markdown-preview").laod()
    require("plugins.markdown.render-markdown").load()
  end,
})
