vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua"
})

require("fzf-lua").setup({
  fzf_colors = true
})

local map = vim.keymap.set

map("n", "<leader>ff", "<cmd>FzfLua files<cr>", {desc = "Find files"})
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", {desc = "Open recent files"})
