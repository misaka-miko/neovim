vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach', {clear = true}),
  callback = function(event)
    -- obtain lsp client
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = "Goto Definition" })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = event.buf, desc = "Goto Declaration" })
    vim.diagnostic.config {
      virtual_text = true,
      float = { severity_sort = true },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = " ",
        }
      },
    }
    vim.keymap.set('n', '<leader>cd', function()
      vim.diagnostic.open_float { source = true }
    end, { buffer = event.buf, desc = "Show Line Diagnostic" })

    if client and client:supports_method 'textdocument/foldingrange' then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set('n', '<leader>ch', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, { buffer = event.buf, desc = "Toggle Inlay Hints" })
    end


  end,
})
