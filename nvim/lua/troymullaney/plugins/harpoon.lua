return {
	"ThePrimeagen/harpoon",
	dependencies = { { "nvim-lua/plenary.nvim" } },
	config = function()
		require("harpoon").setup()
		local harpoon = require("harpoon.mark")
		local uiharpoon = require("harpoon.ui")

		vim.keymap.set("n", "<leader>ma", harpoon.add_file, {})
		vim.keymap.set("n", "<leader>mr", harpoon.rm_file, {})
		vim.keymap.set("n", "<leader>n", uiharpoon.nav_next, {})
		vim.keymap.set("n", "<leader>N", uiharpoon.nav_prev, {})
	end,
}
