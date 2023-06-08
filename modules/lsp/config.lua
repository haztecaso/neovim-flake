-- autoformat on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

require('goto-preview').setup {
  width = 120,
  height = 15,
  preview_window_title = { enable = true, position = "left" },
  default_mappings = true
}

local wk = require("which-key")
wk.register({
  K = {"Code hover"},
  g = {
    D = {"Go to declaration"},
    d = {"Go to definition"},
    i = {"Go to implementation"},
  }
}, {});

wk.register({
  ca = {"Code action"},
  rn = {"Code rename"},
  f  = {"Code format"},
  k  = {"Code go to previous error"},
  j  = {"Code go to next error"},
},{ prefix = "<leader>" })

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
