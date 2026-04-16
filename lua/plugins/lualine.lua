vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = vim.o.laststatus == 3,
    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
  },
})

local function show_macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return "" -- Not recording
  end
  return "recording @" .. reg -- Recording in progress
end

require("lualine").setup({
  sections = {
    lualine_x = {
      { show_macro_recording },
      "encoding",
      "fileformat",
      "filetype",
    },
  },
  extensions = { "fzf", "neo-tree" },
})
