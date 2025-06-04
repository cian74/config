local lsp_zero = require('lsp-zero')


vim.diagnostic.config({
  virtual_text = true,   -- show errors inline (like Primeagen)
  signs = true,          -- icons in the sign column
  underline = true,      -- underline issues
  update_in_insert = false,
  severity_sort = true,
})
-- Setup on_attach for LSP keymaps
lsp_zero.on_attach(function(_, bufnr)
  local opts = {buffer = bufnr}
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end)

-- Setup mason
require('mason').setup()

-- Setup mason-lspconfig and install required LSPs
require('mason-lspconfig').setup({
  ensure_installed = { "ts_ls", "clangd", "pyright" },
  handlers = {
    lsp_zero.default_setup,
  }
})

-- CMP (completions) setup
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-Enter>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp_action.tab_complete(),
    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }
})

