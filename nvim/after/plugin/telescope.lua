local fb = require("telescope").extensions.file_browser

require("telescope").setup({
	defaults = {
		layout_config = { prompt_position = "top" },
		sorting_strategy = "ascending",
	},
	extensions = {
		file_browser = {
			grouped = true,
			mappings = {
				["i"] = {
					["<C-a>"] = fb.actions.create,
					["<C-r>"] = fb.actions.rename,
					["<C-b>"] = fb.actions.copy,
					["<C-z>"] = fb.actions.remove,
				},
				["n"] = {
					["<C-a>"] = fb.actions.create,
					["<C-r>"] = fb.actions.rename,
					["<C-b>"] = fb.actions.copy,
					["<C-z>"] = fb.actions.remove,
				},
			},
		},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>e", fb.file_browser, {})
vim.keymap.set("n", "<leader>ff", function()
	builtin.find_files({
		find_command = {
			"rg",
			"--files",
			"--hidden",
			"--no-ignore",
			"--glob",
			"!**/node_modules/**",
			"--glob",
			"!**/.git/**",
		},
	})
end, {})
vim.keymap.set("n", "<leader>g", function()
	fb.file_browser({ respect_gitignore = false })
end, {})
-- Open telescope-file-browser from within the folder of the current buffer
vim.keymap.set("n", "<leader>t", ":Telescope file_browser path=%:p:h<CR>")
