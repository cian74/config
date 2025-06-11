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
  ensure_installed = { "ts_ls", "clangd", "pyright", },
  handlers = {
    lsp_zero.default_setup,
  }
})

local jdtls_ok, jdtls = pcall(require, 'jdtls')
if jdtls_ok then
  -- Get the Mason install path for jdtls
  local mason_registry = require('mason-registry')
  local jdtls_pkg = mason_registry.get_package('jdtls')
  local jdtls_path = jdtls_pkg:get_install_path()
  
  -- Function to setup jdtls when opening Java files
  local function setup_jdtls()
    local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'})
    if not root_dir then
      return
    end

    -- Workspace directory (unique per project)
    local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

    local config = {
      cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration', jdtls_path .. '/config_mac', -- Change to config_mac or config_win if needed
        '-data', workspace_dir,
      },
      root_dir = root_dir,
      settings = {
        java = {
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = true,
          },
        },
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
          },
        },
        contentProvider = { preferred = 'fernflower' },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },
      flags = {
        allow_incremental_sync = true,
      },
      on_attach = function(client, bufnr)
        -- Apply the common on_attach function
        lsp_zero.on_attach(client, bufnr)
        
        -- Java-specific keymaps
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
        vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
        vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
        vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
      end,
    }
    
    jdtls.start_or_attach(config)
  end

  -- Auto-setup jdtls for Java files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = setup_jdtls,
  })
end

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

