local M = {}

function M.load()
  vim.pack.add({
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  })

  local opts = {
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    checkbox = {
      enabled = false,
    },
  }

  local render_markdown = require("render-markdown")
  render_markdown.setup(opts)
  vim.keymap.set("n", "<leader>um", function()
    render_markdown.toggle()
  end, { desc = "Toggle Markdown Render" })
end

return M
