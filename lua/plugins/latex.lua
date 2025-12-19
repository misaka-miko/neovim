if true then return {} end

return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura_simple"
      -- vim.g.vimtex_format_enabled = 1
    end,
  },
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    opts = {
      formatters_by_ft = {
        tex = { "tex-fmt" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "tex-fmt" } },
  },
}
