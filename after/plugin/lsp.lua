local lsp_zero = require('lsp-zero')

-- Diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Global LSP keymaps
lsp_zero.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end)

-- Mason + mason-lspconfig
require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = { "ts_ls", "clangd", "pyright", "lua_ls" },
  handlers = {
    lsp_zero.default_setup,
    -- Custom handler for lua_ls
    lua_ls = function()
      require('lspconfig').lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
			  checkThirdParty = false
            }
          }
        }
      })
    end,
  },
})

-- fixes undefined global warning
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim"
				}
			}
		}
	}
})

-- nvim-cmp setup
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  snippet = {
	  expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
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
  },
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'java',
	callback = function(args)
		require 'jdtls.jdtls_setup'.setup()
	end
})
