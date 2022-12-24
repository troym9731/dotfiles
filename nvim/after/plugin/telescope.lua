require('telescope').setup {
  defaults = {
    layout_config = {prompt_position = 'top'},
    sorting_strategy = 'ascending',
  },
  extensions = {
    file_browser = {
      grouped = true,
    }
  }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

local builtin = require('telescope.builtin')
local fb = require('telescope').extensions.file_browser
vim.keymap.set('n', '<leader>o', builtin.git_files, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>l', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>e', fb.file_browser, {})
