local fzf = require("fzf-lua")
fzf.setup({
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
	winopts = {
		height = 0.90,
		width = 0.90,
	},
})
vim.keymap.set("n", "<leader>o", fzf.files, {})
vim.keymap.set("n", "<leader>l", fzf.live_grep, {})
