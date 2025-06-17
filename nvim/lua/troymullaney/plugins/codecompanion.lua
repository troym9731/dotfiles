return {
	"olimorris/codecompanion.nvim",
	opts = {},
	config = function()
		require("codecompanion").setup({
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = 'cmd:op read --account https://family-mullaney.1password.com/ "op://private/codecompanion anthropic/credential" --no-newline',
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>cc", ":CodeCompanionChat Toggle<CR>", { silent = true })
		vim.keymap.set({ "n", "v" }, "<leader>ci", ":CodeCompanion")
	end,
}
