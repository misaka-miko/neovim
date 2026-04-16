local M = {} -- Setup module
local H = {}

M.setup = function(config)
  _G.Misc = M
  config = H.setup_config
  H.apply_config = config
end

M.find_root = function(buf_id, names)
  buf_id = buf_id or 0
  names = names or { ".git", "Makefile" }

  if type(buf_id) ~= "number" then
    H.error("Argument `buf_id` of `misc.find_root` should be number.")
  end
  if not (H.is_array_of(names, H.is_string) or vim.is_callable(names)) then
    H.error("Argument `names` of `misc.find_root` should be array of string file names or a callable.")
  end

  local path = vim.api.nvim_buf_get_name(buf_id)
  if path == "" then
    return
  end
  path = vim.fs.dirname(path)

  local res = H.root_cache[path]
  if res ~= nil then
    return res
  end

  local root_file = vim.fs.find(names, { path = path, upward = true })[1]
  if root_file == nil then
    return
  end

  res = vim.fn.fnamemodify(vim.fs.dirname(root_file), ":p")
  H.root_cache[path] = res

  return res
end

H.root_cache = {}

M.setup_auto_root = function(names)
  if vim.fs == nil then
    vim.notify("(misc) `setup_auto_root()` requires `vim.fs`")
    return
  end
  if not (H.is_array_of(names, H.is_string) or vim.is_callable(names)) then
    H.error("Argument `names` of `misc.setup_auto_root` should be array of string file names or a callable.")
  end

  vim.o.autochdir = false
  local set_root = function()
    local root = M.find_root(0, names)
    if root == nil then
      return
    end
    vim.fn.chdir(root)
  end
  local root_augroup = vim.api.nvim_create_augroup("MiscAutoRoot", { clear = true })
  vim.api.nvim_create_autocmd(
    "BufEnter",
    { group = root_augroup, callback = set_root, desc = "Find root and change current directory" }
  )
end

H.apply_config = function(config)
  M.config = config

  for _, v in pairs(config.make_global) do
    _G[v] = M[v]
  end
end

-- utilities
H.error = function(msg)
  error(string.format("(mini.misc) %s", msg))
end

H.is_array_of = function(x, predicate)
  if not vim.islist(x) then
    return false
  end
  for _, v in ipairs(x) do
    if not predicate(v) then
      return false
    end
  end
  return true
end

H.is_number = function(x)
  return type(x) == "number"
end

H.is_string = function(x)
  return type(x) == "string"
end

return M
