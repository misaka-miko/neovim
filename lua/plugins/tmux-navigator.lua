local M = {}

M.loaded = false

local function is_tmux()
  return os.getenv("TMUX") ~= nil or os.getenv("TERM_PROGRAM") == "tmux"
end

if not is_tmux() then
  return
end

local function load()
  if M.loaded then
    return
  end
  vim.pack.add({
    "https://github.com/christoomey/vim-tmux-navigator",
  })

  vim.keymap.set("n", "<C-h>", function()
    vim.cmd("TmuxNavigateLeft")
  end, { desc = "Move to Left Window" })

  vim.keymap.set("n", "<C-j>", function()
    vim.cmd("TmuxNavigateDown")
  end, { desc = "Move to Lower Window" })

  vim.keymap.set("n", "<C-k>", function()
    vim.cmd("TmuxNavigateUp")
  end, { desc = "Move to Upper Window" })

  vim.keymap.set("n", "<C-l>", function()
    vim.cmd("TmuxNavigateRight")
  end, { desc = "Move to Right Window" })
end

vim.keymap.set("n", "<C-h>", function()
  load()
  vim.cmd("TmuxNavigateLeft")
end, { desc = "Move to Left Window" })

vim.keymap.set("n", "<C-j>", function()
  load()
  vim.cmd("TmuxNavigateDown")
end, { desc = "Move to Lower Window" })

vim.keymap.set("n", "<C-k>", function()
  load()
  vim.cmd("TmuxNavigateUp")
end, { desc = "Move to Upper Window" })

vim.keymap.set("n", "<C-l>", function()
  load()
  vim.cmd("TmuxNavigateRight")
end, { desc = "Move to Right Window" })
return M
