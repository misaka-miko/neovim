vim.pack.add({
  "https://github.com/nvimdev/dashboard-nvim",
})

local db = require("dashboard")

db.setup({
  theme = "hyper",
  config = {
    shortcut = {
      {
        desc = "󰈞 Find Files",
        group = "DashboardShortCut",
        key = "f",
        action = "FzfLua files",
      },
      {
        desc = "󰈚 Recent Files",
        group = "DashboardShortCut",
        key = "r",
        action = "FzfLua oldfiles",
      },
      {
        desc = "󰭎 New File",
        group = "DashboardShortCut",
        key = "n",
        action = "enew",
      },
      {
        desc = "󰺮 Live Grep",
        group = "DashboardShortCut",
        key = "g",
        action = "FzfLua live_grep",
      },
      {
        desc = "󰊢 Git Status",
        group = "DashboardShortCut",
        key = "s",
        action = "FzfLua git_status",
      },
      {
        desc = " Quit",
        group = "DashboardShortCut",
        key = "q",
        action = "qa",
      },
    },

    project = {
      enable = true,
      limit = 8,
      icon = "󰉋 ",
      label = "Projects",
      action = "FzfLua files cwd=",
    },
    mru = {
      enable = true,
      limit = 10,
      icon = "󰈚 ",
      label = "Recent",
      cwd_only = false,
    },

    week_header = {
      enable = true,
    },
    packages = { enable = true },
    footer = {
      "⚡ Neovim loaded successfully",
    },
  },
})
