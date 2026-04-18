local M = {}

M.loaded = false

local function load()
  if M.loaded then
    return
  end
  M.loaded = true

  vim.pack.add({
    "https://github.com/folke/todo-comments.nvim",
  })

  require("todo-comments").setup({})

  vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
  end, { desc = "Next todo comment" })
  vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { desc = "Previous todo comment" })
  vim.keymap.set("n", "<leader>st", function()
    require("todo-comments.fzf").todo()
  end, { desc = "Todo" })
  vim.keymap.set("n", "<leader>sT", function()
    require("todo-comments.fzf").todo({ "TODO", "FIX", "FIXME" })
  end, { desc = "Todo/Fix/Fixme" })
end

vim.keymap.set("n", "]t", function()
  load()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", function()
  load()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
vim.keymap.set("n", "<leader>st", function()
  load()
  require("todo-comments.fzf").todo()
end, { desc = "Todo" })
vim.keymap.set("n", "<leader>sT", function()
  load()
  require("todo-comments.fzf").todo({ "TODO", "FIX", "FIXME" })
end, { desc = "Todo/Fix/Fixme" })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("TodoLazySetup", { clear = true }),
  once = true,
  callback = function()
    load()
  end,
  desc = "Lazy load todo-comments for highlighting",
})

return M
