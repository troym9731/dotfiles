return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		presets = {
			command_palette = true,
		},
		routes = {
			{
				view = "notify",
				filter = { event = "msg_showmode" },
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
}
