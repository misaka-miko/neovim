vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim"
})

require('lualine').setup({
  options = {
    theme = 'auto',
    globalstatus = vim.o.laststatus == 3,
    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
  }
})
