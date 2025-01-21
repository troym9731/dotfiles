return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		build = "make",
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon").setup()

			local harpoon = require("harpoon.mark")
			local uiharpoon = require("harpoon.ui")

			vim.keymap.set("n", "<leader>ma", harpoon.add_file, { silent = true })
			vim.keymap.set("n", "<leader>mr", harpoon.rm_file, { silent = true })
			vim.keymap.set("n", "<leader>n", uiharpoon.nav_next, { silent = true })
			vim.keymap.set("n", "<leader>N", uiharpoon.nav_prev, { silent = true })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local fb = require("telescope").extensions.file_browser

			require("telescope").setup({
				defaults = {
					layout_config = { prompt_position = "top" },
					sorting_strategy = "ascending",
					path_display = { "truncate" },
				},
				extensions = {
					file_browser = {
						grouped = true,
						mappings = {
							["i"] = {
								["<C-a>"] = fb.actions.create,
								["<C-j>"] = fb.actions.rename,
								["<C-b>"] = fb.actions.copy,
								["<C-z>"] = fb.actions.remove,
							},
							["n"] = {
								["<C-a>"] = fb.actions.create,
								["<C-j>"] = fb.actions.rename,
								["<C-b>"] = fb.actions.copy,
								["<C-z>"] = fb.actions.remove,
							},
						},
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("harpoon")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>b", builtin.buffers, { silent = true })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { silent = true })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { silent = true })
			vim.keymap.set("n", "<leader>o", builtin.find_files, { silent = true })
			vim.keymap.set("n", "<leader>l", builtin.live_grep, { silent = true })
			vim.keymap.set("n", "<leader>e", fb.file_browser, { silent = true })
			vim.keymap.set("n", "<leader>fj", builtin.git_status, { silent = true })
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
			end, { silent = true })
			vim.keymap.set("n", "<leader>g", function()
				fb.file_browser({ respect_gitignore = false })
			end, { silent = true })
			-- Open telescope-file-browser from within the folder of the current buffer
			vim.keymap.set("n", "<leader>t", ":Telescope file_browser path=%:p:h<CR>", { silent = true })
			-- Open Harpoon marks
			vim.keymap.set("n", "<leader>h", ":Telescope harpoon marks<CR>", { silent = true })
		end,
	},
}
-- If I ever need fzf-lua again for performance
-- return {
-- 	{
-- 		"ibhagwan/fzf-lua",
-- 		dependencies = { "nvim-tree/nvim-web-devicons" },
-- 		config = function()
-- 			local fzf = require("fzf-lua")
-- 			fzf.setup({
-- 				winopts = {
-- 					height = 0.90,
-- 					width = 0.90,
-- 				},
-- 			})
-- 			vim.keymap.set("n", "<leader>o", fzf.files, {})
-- 			vim.keymap.set("n", "<leader>l", fzf.live_grep, {})
-- 		end,
-- 	},
-- }
