local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'sumneko_lua',
})

local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
cmp_mappings['<CR>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.setup()
