vim.pack.add({
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.indentscope",
})

package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

require("mini.icons").setup({
  file = {
    [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
    ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
  },
  filetype = {
    dotenv = { glyph = "", hl = "MiniIconsYellow" },
  },
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("SurroundLazy", { clear = true }),
  desc = "Lazy loading mini surround",
  once = true,
  callback = function()
    require("mini.pairs").setup({
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    })
  end,
})

require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "Trouble",
    "alpha",
    "dashboard",
    "fzf",
    "help",
    "lazy",
    "mason",
    "neo-tree",
    "notify",
    "sidekick_terminal",
    "snacks_dashboard",
    "snacks_notif",
    "snacks_terminal",
    "snacks_win",
    "toggleterm",
    "terminal",
    "trouble",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
