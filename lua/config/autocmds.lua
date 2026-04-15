local function augroup(name)
  return vim.api.nvim_create_augroup("misaka_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dap-float",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

local root_cache = {}

local find_root = function (buf_id, names)
  buf_id = buf_id or 0
  names = names or { '.git', 'Makefile' }

  local path = vim.api.nvim_buf_get_name(buf_id)
  if path == '' then return end
  path = vim.fs.dirname(path)

  local res = root_cache[path]
  if res ~= nil then return res end

  local root_file = vim.fs.find(names, { path = path, upward = true})[1]
  if root_file == nil then return end

  res = vim.fn.fnamemodify(vim.fs.dirname(root_file), ':p')
  root_cache[path] = res

  return res
end

local setup_auto_root = function (names)
  if vim.fs == nil then
    vim.notify("`setup_auto_root` requires `vim.fs`")
    return
  end

  names = names or { '.git', 'Makefile' }

  vim.o.autochdir = false
  local set_root = function ()
    local root = find_root(0, names)
    if root == nil then return end
    vim.fn.chdir(root)
  end
  local root_augroup = vim.api.nvim_create_augroup("root_dir",{clear= true})
  vim.api.nvim_create_autocmd("BufEnter", {group = root_augroup, callback = set_root, desc = 'Find root and change current directory'})
end

local root_files = {".git", "Makefile", "package.json", "go.mod", "lua" }

setup_auto_root(root_files)
