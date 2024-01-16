return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	dependencies = { "nvim-lua/plenary.nvim" },
	notes_subdir = "notes",
	opts = {
		workspaces = {
			{
				name = "main",
				path = "~/vaults/main",
			},
		},
	},
}
