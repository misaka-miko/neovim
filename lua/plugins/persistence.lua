local M = {}

M.loaded = false

local function load()
  if M.loaded then
    return
  end
  M.loaded = true

  vim.pack.add({
    "https://github.com/folke/persistence.nvim",
  })

  require("persistence").setup()

  vim.keymap.set("n", "<leader>qs", function()
    require("persistence").load()
  end, { desc = "Restore Session" })
  vim.keymap.set("n", "<leader>ql", function()
    require("persistence").load({ last = true })
  end, { desc = "Restore Last Session" })
  vim.keymap.set("n", "<leader>qd", function()
    require("persistence").stop()
  end, { desc = "Don't Save Current Session" })
end

vim.keymap.set("n", "<leader>qs", function()
  load()
  require("persistence").load()
end, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>ql", function()
  load()
  require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qd", function()
  load()
  require("persistence").stop()
end, { desc = "Don't Save Current Session" })

return M
