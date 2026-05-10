vim.pack.add({
  "https://github.com/saghen/blink.lib",
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  "https://github.com/saghen/blink.cmp",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("nvim_completion_setup", { clear = true }),
  once = true,
  callback = function()
    pcall(function()
      require("blink.cmp").build():wait(60000)
    end)

    require("blink.cmp").setup({
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
      },
      keymap = {
        preset = "default",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
    })
  end,
})
