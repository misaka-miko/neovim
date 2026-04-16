vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("pyright")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(event)
    -- obtain lsp client
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Goto Definition", remap = true })
    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf, desc = "Goto Reference", remap = true })
    -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "Goto Declaration", remap = true })
    -- vim.keymap.set(
    --   "n",
    --   "gI",
    --   vim.lsp.buf.implementation,
    --   { buffer = event.buf, desc = "Goto Implementation", remap = true }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   "gy",
    --   vim.lsp.buf.type_definition,
    --   { buffer = event.buf, desc = "Goto Type Definition", remap = true }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   "<leader>ss",
    --   vim.lsp.buf.document_symbol,
    --   { buffer = event.buf, desc = "Goto Symbol", remap = true }
    -- )
    -- vim.keymap.set(
    --   "n",
    --   "<leader>sS",
    --   vim.lsp.buf.workspace_symbol,
    --   { buffer = event.buf, desc = "Goto Symbol (workspace)", remap = true }
    -- )
    -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Goto Type Definition", remap = true })
    -- vim.keymap.set(
    --   { "n", "x" },
    --   "<leader>ca",
    --   vim.lsp.buf.code_action,
    --   { buffer = event.buf, desc = "Code Action", remap = true }
    -- )
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename" })

    vim.diagnostic.config({
      underline = true,
      virtual_text = true,
      virtual_lines = false,
      float = { severity_sort = true },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = " ",
        },
      },
    })
    vim.keymap.set("n", "<leader>cd", function()
      vim.diagnostic.open_float({ source = true })
    end, { buffer = event.buf, desc = "Show Line Diagnostic" })

    if client and client:supports_method("textdocument/foldingrange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, { buffer = event.buf, desc = "Toggle Inlay Hints" })
    end
  end,
})
