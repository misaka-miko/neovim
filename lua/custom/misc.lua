local Misc = {} -- Setup module
local H = {}

Misc.setup = function(config)
  _G.Misc = Misc
  config = H.setup_config
  H.apply_config = config
end

Misc.find_root = function(buf_id, names)
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

Misc.setup_termbg_sync = function(opts)
  -- Handling `'\027]11;?\007'` response was added in Neovim 0.10
  if vim.fn.has("nvim-0.10") == 0 then
    return H.notify("`setup_termbg_sync()` requires Neovim>=0.10", "WARN")
  end

  -- Proceed only if there is a valid stdout to use
  local has_stdout_tty = false
  for _, ui in ipairs(vim.api.nvim_list_uis()) do
    has_stdout_tty = has_stdout_tty or ui.stdout_tty
  end
  if not has_stdout_tty then
    return
  end

  opts = vim.tbl_extend("force", { explicit_reset = false }, opts or {})

  -- Choose a method for how terminal emulator background is reset
  local reset = function()
    io.stdout:write("\027]111\027\\")
  end
  if opts.explicit_reset then
    reset = function()
      io.stdout:write("\027]11;" .. H.termbg_init .. "\007")
    end
  end

  local augroup = vim.api.nvim_create_augroup("MiscTermbgSync", { clear = true })
  local track_au_id, bad_responses, had_proper_response = nil, {}, false
  local f = function(args)
    -- Process proper response only once
    if had_proper_response then
      return
    end

    -- Neovim=0.10 uses string sequence as response, while Neovim>=0.11 sets it
    -- in `sequence` table field
    local seq = type(args.data) == "table" and args.data.sequence or args.data
    local ok, termbg = pcall(H.parse_osc11, seq)
    if not (ok and type(termbg) == "string") then
      return table.insert(bad_responses, seq)
    end
    had_proper_response = true
    pcall(vim.api.nvim_del_autocmd, track_au_id)

    -- Set up reset to the color returned from the very first call
    H.termbg_init = H.termbg_init or termbg
    vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, { group = augroup, callback = reset })

    -- Set up sync
    local sync = function()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
      if normal.bg == nil then
        return reset()
      end
      -- NOTE: use `io.stdout` instead of `io.write` to ensure correct target
      -- Otherwise after `io.output(file); file:close()` there is an error
      io.stdout:write(string.format("\027]11;#%06x\007", normal.bg))
    end
    vim.api.nvim_create_autocmd({ "VimResume", "ColorScheme" }, { group = augroup, callback = sync })

    -- Sync immediately
    sync()
  end

  -- Ask about current background color and process the proper response.
  -- NOTE: do not use `once = true` as Neovim itself triggers `TermResponse`
  -- events during startup, so this should wait until the proper one.
  track_au_id = vim.api.nvim_create_autocmd("TermResponse", { group = augroup, callback = f, nested = true })
  io.stdout:write("\027]11;?\007")
  vim.defer_fn(function()
    if had_proper_response then
      return
    end
    pcall(vim.api.nvim_del_augroup_by_id, augroup)
    local bad_suffix = #bad_responses == 0 and "" or (", only these: " .. vim.inspect(bad_responses))
    local msg = "`setup_termbg_sync()` did not get proper response from terminal emulator" .. bad_suffix
    H.notify(msg, "WARN")
  end, 1000)
end

-- Source: 'runtime/lua/vim/_defaults.lua' in Neovim source
H.parse_osc11 = function(x)
  local r, g, b = x:match("^\027%]11;rgb:(%x+)/(%x+)/(%x+)$")
  if not (r and g and b) then
    local a
    r, g, b, a = x:match("^\027%]11;rgba:(%x+)/(%x+)/(%x+)/(%x+)$")
    if not (a and a:len() <= 4) then
      return
    end
  end
  if not (r and g and b) then
    return
  end
  if not (r:len() <= 4 and g:len() <= 4 and b:len() <= 4) then
    return
  end
  local parse_osc_hex = function(c)
    return c:len() == 1 and (c .. c) or c:sub(1, 2)
  end
  return "#" .. parse_osc_hex(r) .. parse_osc_hex(g) .. parse_osc_hex(b)
end

Misc.setup_auto_root = function(names)
  if vim.fs == nil then
    vim.notify("(misc) `setup_auto_root()` requires `vim.fs`")
    return
  end
  if not (H.is_array_of(names, H.is_string) or vim.is_callable(names)) then
    H.error("Argument `names` of `misc.setup_auto_root` should be array of string file names or a callable.")
  end

  vim.o.autochdir = false
  local set_root = function()
    local root = Misc.find_root(0, names)
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
  Misc.config = config

  for _, v in pairs(config.make_global) do
    _G[v] = Misc[v]
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

H.notify = function(msg, level)
  vim.notify("(misc) " .. msg, vim.log.levels[level])
end

return Misc
