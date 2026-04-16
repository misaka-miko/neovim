vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
})

require("fzf-lua").setup({
  fzf_colors = true,
})

local map = vim.keymap.set

map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files (root dir)" })
map("n", "<leader><space>", "<cmd>FzfLua files<cr>", { desc = "Find Files (root dir)" })
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Find Recent Files" })
map("n", "<leader>fR", "<cmd>FzfLua oldfiles cwd_only<cr>", { desc = "Find Recent Files (cwd)" })
map("n", "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", { desc = "Buffers" })
map("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", { desc = "Live Grep (root dir)" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Live Grep (root dir)" })
map("n", "<leader>fB", "<cmd>FzfLua buffers<cr>", { desc = "Buffers (all)" })
map("n", "<leader>fg", "<cmd>FzfLua git_files<cr>", { desc = "Find Files (git files)" })

map("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Git Commits" })
map("n", "<leader>gd", "<cmd>FzfLua git_diff<cr>", { desc = "Git Diff (files)" })
map("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })
map("n", "<leader>gS", "<cmd>FzfLua git_stash<cr>", { desc = "Git Stash" })
