local map = vim.keymap.set
local function desc_opts(description)
  return {
    desc = description,
    silent = true,
    remap = false,
  }
end

-- package udpate
map("n", "<leader>pa", "<cmd>lua vim.pack.update()<cr>", desc_opts("Package Upgrage"))

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("i", "jk", "<Esc>", desc_opts("Escape"))
map("i", "jj", "<Esc>", desc_opts("Escape"))

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
  local bufnr = vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  local buftype = vim.bo[bufnr].buftype
  if buftype == "nofile" or buftype == "terminal" then
    vim.cmd("close")
    return
  end

  local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed_bufs > 1 then
    vim.cmd("bp")
    vim.cmd("bd! " .. bufnr)
  else
    vim.cmd("bd!")
  end
end, { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
vim.keymap.set("n", "<leader>bo", function()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(bufs) do
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, { desc = "Close Other Buffers" })
--
-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map("n", "<leader>-", "<C-w>s", desc_opts("Split Window Below"))
map("n", "<leader>|", "<C-w>v", desc_opts("Split Window Right"))
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<C-h>", "<C-w>h", { desc = "Move to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to Right Window" })

map("n", "<leader>qq", "<cmd>qa<cr>", desc_opts("Quit All Files"))
map("n", "<leader>rr", "<cmd>restart<cr>", desc_opts("Restart Neovim"))

map("x", "<", "<gv")
map("x", ">", ">gv")
