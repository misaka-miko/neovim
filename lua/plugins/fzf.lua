vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
})

require("fzf-lua").setup({
  "default-title",
  winopts = {
    width = 0.90,
    height = 0.85,
    row = 0.55,
    col = 0.50,
    border = "rounded",
    backdrop = 60,
    preview = {
      layout = "flex",
      horizontal = "right:55%",
      vertical = "down:45%",
      flip_columns = 120,
      border = "rounded",
      scrollbar = "float",
      title = true,
      title_pos = "center",
      delay = 20,
      winopts = {
        number = true,
        cursorline = true,
        cursorlineopt = "both",
        signcolumn = "no",
      },
    },
  },
  fzf_opts = {
    ["--layout"] = "reverse",
    ["--info"] = "inline-right",
    ["--highlight-line"] = true,
  },
  keymap = {
    builtin = {
      ["<C-f>"] = "preview-page-down",
      ["<C-b>"] = "preview-page-up",
    },
    fzf = {
      ["ctrl-d"] = "half-page-down",
      ["ctrl-u"] = "half-page-up",
      ["ctrl-f"] = "preview-page-down",
      ["ctrl-b"] = "preview-page-up",
    },
  },
  fzf_colors = true,

  files = {
    cwd_prompt = false,
    actions = {
      ["alt-i"] = { require("fzf-lua").actions.toggle_ignore },
      ["alt-h"] = { require("fzf-lua").actions.toggle_hidden },
    },
  },
  grep = {
    actions = {
      ["alt-i"] = { require("fzf-lua").actions.toggle_ignore },
      ["alt-h"] = { require("fzf-lua").actions.toggle_hidden },
    },
  },
})
local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files (root dir)" })
map("n", "<leader><space>", "<cmd>FzfLua files<cr>", { desc = "Find Files (root dir)" })
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Find Recent Files" })
map("n", "<leader>fR", "<cmd>lua FzfLua.oldfiles( {cwd = vim.uv.cwd() } )<cr>", { desc = "Find Recent Files (cwd)" })
map("n", "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", { desc = "Buffers" })
map("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", { desc = "Live Grep (root dir)" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Live Grep (root dir)" })
map("n", "<leader>fB", "<cmd>FzfLua buffers<cr>", { desc = "Buffers (all)" })
map("n", "<leader>fg", "<cmd>FzfLua git_files<cr>", { desc = "Find Files (git files)" })
map("n", "<leader>fc", "<cmd>lua FzfLua.files({ cwd = '~/.config/nvim' })<cr>", { desc = "Find Config Files" })

map("n", "<leader>sb", "<cmd>FzfLua lines<cr>", { desc = "Buffer Lines" })
map("n", "<leader>sa", "<cmd>FzfLua autocmds<cr>", { desc = "Auto Commands" })
map("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", { desc = "Key Maps" })
map("n", "<leader>sc", "<cmd>FzfLua command_history<cr>", { desc = "Command History" })
map("n", "<leader>sC", "<cmd>FzfLua commands<cr>", { desc = "Commands" })
map("n", "<leader>sq", "<cmd>FzfLua quickfix<cr>", { desc = "Quickfix List" })
map("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>", { desc = "Search Word Under Cursor" })
map("n", "<leader>uc", "<cmd>FzfLua colorschemes<cr>", { desc = "Select Colorscheme" })
map("n", "<leader>ss", function()
  require("fzf-lua").lsp_document_symbols({
    regex_filter = symbols_filter,
  })
end, { desc = "Goto Symbol" })
map("n", "<leader>sS", function()
  require("fzf-lua").lsp_live_workspace_symbols({
    regex_filter = symbols_filter,
  })
end, { desc = "Goto Symbol (workspace)" })

map("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Git Commits" })
map("n", "<leader>gd", "<cmd>FzfLua git_diff<cr>", { desc = "Git Diff (files)" })
map("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })
map("n", "<leader>gS", "<cmd>FzfLua git_stash<cr>", { desc = "Git Stash" })

-- lsp keymaps
map("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Goto Definition (fzf)" })
map("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", { desc = "Goto Declaration (fzf)" })
map("n", "gI", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Goto Implementation (fzf)" })
map("n", "gr", "<cmd>FzfLua lsp_references<cr>", { desc = "Goto Reference (fzf)" })
map("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Goto Type Definition (fzf)" })
map({ "n", "x" }, "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "Code Action (fzf)" })
