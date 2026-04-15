return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			integrations = {
				cmp = true,
				gitsigns = true,
			},
		})
		vim.cmd([[colorscheme catppuccin-mocha]])
	end,
}
