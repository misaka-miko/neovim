vim.pack.add({
  "https://github.com/nvim-mini/mini.pairs",
})

local opts = {
  modes = { insert = true, command = true, terminal = false },
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  -- skip autopair when the cursor is inside these treesitter nodes
  skip_ts = { "string" },
  -- and there are more closing pairs than opening pairs
  skip_unbalanced = true,
  -- better deal with markdown code blocks
  markdown = true,
}

vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("SurroundLazy", { clear = true }),
  desc = "Lazy loading mini surround",
  once = true,
  callback = function()
    require("mini.pairs").setup(opts)
  end,
})
