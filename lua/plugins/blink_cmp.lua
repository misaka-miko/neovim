vim.pack.add({
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  "https://github.com/saghen/blink.cmp",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("nvim_completion_setup", { clear = true }),
  once = true,
  callback = function()
    require("blink.cmp").setup({
      fuzzy = {
        prebuilt_binaries = {
          force_version = "v*",
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
