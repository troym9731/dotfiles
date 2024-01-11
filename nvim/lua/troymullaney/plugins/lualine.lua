return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = false,
				theme = "catppuccin",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = { "branch" },
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
