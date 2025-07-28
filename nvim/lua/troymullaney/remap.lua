vim.g.mapleader = " "

vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>P", '"+P')

vim.keymap.set("n", "<leader>\\", ":vsplit<CR>", { silent = true })
vim.keymap.set("n", "<leader>-", ":split<CR>", { silent = true })
vim.keymap.set("n", "<leader>d", ":close<CR>", { silent = true })
vim.keymap.set("n", "<leader>s", ":b#<CR>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "M", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "elixir",
	callback = function()
		-- Disable some problematic indent triggers
		vim.bo.indentkeys = "0},0),0],!^F,o,O,e" -- Remove >, {, and | from indent keys
	end,
})
