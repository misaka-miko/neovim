local M = {}

M.loaded = false

local function load()
  if M.loaded then
    return
  end
  M.loaded = true

  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    {
      src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
      version = vim.version.range("3"),
    },
  })

  require("neo-tree").setup({
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    source_selector = {
      winbar = true,
      statusline = false,
    },
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
        end,
      },
      {
        event = "neo_tree_window_after_close",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
        end,
      },
    },
    close_if_last_window = true,
    popup_border_style = "",
    window = {
      mappings = {
        ["e"] = function()
          vim.cmd("Neotree focus filesystem left")
        end,
        ["b"] = function()
          vim.cmd("Neotree focus buffers left")
        end,
        ["g"] = function()
          vim.cmd("Neotree focus git_status left")
        end,
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
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
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
    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
  end, { desc = "Explorer Neotree (Root Dir)" })
  vim.keymap.set("n", "<leader>ge", function()
    require("neo-tree.command").execute({ source = "git_status", toggle = true })
  end, { desc = "Git Explorer" })
  vim.keymap.set("n", "<leader>be", function()
    require("neo-tree.command").execute({ source = "buffers", toggle = true })
  end, { desc = "Buffer Explorer" })
  vim.keymap.set("n", "<leader>cs", function()
    require("neo-tree.command").execute({ source = "document_symbols", toggle = false, position = "right" })
  end, { desc = "Buffer Explorer" })
end

vim.keymap.set("n", "<leader>e", function()
  load()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end, { desc = "Explorer Neotree (Root Dir)" })
vim.keymap.set("n", "<leader>ge", function()
  load()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git Explorer" })
vim.keymap.set("n", "<leader>be", function()
  load()
  require("neo-tree.command").execute({ source = "buffers", toggle = true })
end, { desc = "Buffer Explorer" })
vim.keymap.set("n", "<leader>cs", function()
  load()
  require("neo-tree.command").execute({ source = "document_symbols", toggle = false, position = "right" })
end, { desc = "Buffer Explorer" })

return M
