vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  {
    src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
    version = vim.version.range("3"),
  },
  "https://github.com/s1n7ax/nvim-window-picker",
})

require("window-picker").setup({
  filter_rules = {
    include_current_win = false,
    autoselect_one = true,
    -- filter using buffer options
    bo = {
      -- if the file type is one of following, the window will be ignored
      filetype = { "neo-tree", "neo-tree-popup", "notify" },
      -- if the buffer type is one of following, the window will be ignored
      buftype = { "terminal", "quickfix" },
    },
  },
})

require("neo-tree").setup({
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  event_handlers = {
    --{
    --  event = "neo_tree_window_before_open",
    --  handler = function(args)
    --    print("neo_tree_window_before_open", vim.inspect(args))
    --  end
    --},
    {
      event = "neo_tree_window_after_open",
      handler = function(args)
        if args.position == "left" or args.position == "right" then
          vim.cmd("wincmd =")
        end
      end,
    },
    --{
    --  event = "neo_tree_window_before_close",
    --  handler = function(args)
    --    print("neo_tree_window_before_close", vim.inspect(args))
    --  end
    --},
    {
      event = "neo_tree_window_after_close",
      handler = function(args)
        if args.position == "left" or args.position == "right" then
          vim.cmd("wincmd =")
        end
      end,
    },
  },
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "", -- or "" to use 'winborder' on Neovim v0.11+
  window = {
    mappings = {
      ["l"] = "open",
      ["h"] = "close_node",
      ["<space>"] = "none",
      ["<C-r>"] = "none",
      ["Y"] = {
        function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.setreg("+", path, "c")
        end,
        desc = "Copy Path to Clipboard",
      },
      ["P"] = { "toggle_preview", config = { use_float = true } },
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚"
        modified = "", -- or ""
        deleted = "✖", -- this can only be used in the git_status source
        renamed = "󰁕", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",
        conflict = "",
      },
    },
  },
})

vim.keymap.set("n", "<leader>e", function()
  require("neo-tree.command").execute({
    toggle = true,
    dir = vim.uv.cwd(),
  })
end, { desc = "Explorer Neotree (Root Dir)" })

vim.keymap.set("n", "<leader>ge", function()
  require("neo-tree.command").execute({
    source = "git_status",
    toggle = true,
  })
end, { desc = "Git Explorer" })

vim.keymap.set("n", "<leader>be", function()
  require("neo-tree.command").execute({
    source = "buffers",
    toggle = true,
  })
end, { desc = "Buffer Explorer" })

vim.keymap.set("n", "<leader>cs", function()
  require("neo-tree.command").execute({
    source = "document_symbols",
    toggle = false,
    position = "right",
  })
end, { desc = "Buffer Explorer" })
